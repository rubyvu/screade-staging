class Stream < ApplicationRecord
  
  # Statuses
  # pending     - New Stream was created and waiting for running in AWS Media Live
  # in-progress - Stream is running in AWS Medialive and waiting video from client
  # completed   - Client is successfully end video streaming, wait for Video file to save, stop and clear AWS dependencies
  # finished    - Client is successfully saved stream Video, now it can be show in Stream list (status updated in StreamVideoUploader callback)
  # failed       - Error occurred while AWS services deploying, stream will be stopped, error will be added to object.error_message field, all AWS dependencies will be cleared
  
  # Constants
  STATUS_LIST = %w(pending in-progress completed finished failed)
  GROUP_TYPES = %w(NewsCategory Topic)
  VIDEO_RESOLUTIONS = %w(mp4)
  
  # Callbacks
  before_validation :generate_access_token, on: :create
  after_update :start_in_progress_tracker, if: -> { self.status == 'in-progress'}
  after_commit :create_aws_media, on: :create
  after_commit :remove_aws_media, on: :update
  before_destroy :check_for_status, prepend: true
  # after_save :add_notification
  
  # File Uploader
  mount_uploader :image, StreamImageUploader
  mount_uploader :video, StreamVideoUploader
  
  # Associations
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  belongs_to :group, polymorphic: true, optional: true
  has_and_belongs_to_many :users
  
  ## Comments
  has_many :stream_comments, dependent: :destroy
  has_many :commenting_users, through: :stream_comments, source: :user
  ## Lits
  has_many :lits, as: :source, dependent: :destroy
  has_many :liting_users, through: :lits, source: :user
  ## Views
  has_many :views, as: :source, dependent: :destroy
  has_many :viewing_users, through: :views, source: :user
  # Notifications
  # has_many :notifications, as: :source, dependent: :destroy
  
  # Association validations
  validates :owner, presence: true
  
  # Fields validations
  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: Stream::STATUS_LIST }
  validates :group, presence: true, if: -> { !self.is_private }
  
  def is_lited(user)
    user.present? && self.liting_users.include?(user)
  end
  
  def is_commented(user)
    user.present? && self.commenting_users.include?(user)
  end
  
  def is_viewed(user)
    user.present? && self.viewing_users.include?(user)
  end
  
  private
    def add_notification
      return if !self.is_approved || Notification.where(source_id: self.id, source_type: 'Post', sender: self.user).present? || !self.is_notification
      CreateNewNotificationsJob.perform_later(self.id, self.class.name)
    end
    
    def generate_access_token
      new_token = SecureRandom.hex(16)
      Stream.exists?(access_token: new_token) ? generate_access_token : self.access_token = new_token
    end
    
    def create_aws_media
      puts "===== Start AWS requsts"
      input_security_group = Tasks::AwsMediaLiveApi.get_input_security_group
      if input_security_group.blank?
        set_failed_status('Input security group cannot be created.')
        return
      end
      
      puts "===== 1 Security group created"
      channel_input_to_attach = Tasks::AwsMediaLiveApi.create_input(self.access_token, input_security_group)
      puts "ISG: #{input_security_group}"
      if input_security_group.blank?
        set_failed_status('Channel Input cannot be created.')
        return
      end
      
      puts "===== 2 Input channel created"
      channel = Tasks::AwsMediaLiveApi.create_channel(self.access_token, channel_input_to_attach)
      if channel.blank?
        set_failed_status('Channel cannot be created.')
        return
      end
      
      puts "===== 3 GET channel ID and input ID"
      channel_id = channel.id
      channel_input_id = channel['input_attachments'][0]['input_id']
      if channel_input_id.blank?
        set_failed_status('Channel ID should be present.')
        return
      end
      
      puts "===== 4 GET RTMP URL"
      input_rtmp_url = Tasks::AwsMediaLiveApi.get_input_url(channel_input_id.to_s)
      if input_rtmp_url.blank?
        set_failed_status('Input attachments should be present.')
        return
      end
      
      puts "===== 5 Done"
      # Save chanel data
      aws_channel_params = {
        channel_id: channel_id,
        channel_input_id: channel_input_id,
        channel_security_group_id: input_security_group[:id],
        rtmp_url: input_rtmp_url,
        stream_url: "https://#{ENV['AWS_STREAM_CLOUD_FRONT_DOMAIN_NAME']}/#{self.access_token}/index.m3u8"
      }
      self.update_columns(aws_channel_params)
      
      # Start Stream Chanel
      StartStreamChannelsJob.perform_later(self.id)
    end
    
    def remove_aws_media
      return if ['completed', 'failed'].exclude?(self.status) && self.channel_id.present?
      # Delete attached input and Channel from AWS services
      
      # Run Channel stopping proccess
      Tasks::AwsMediaLiveApi.channel_stop(self.channel_id)
      
      # Delete Stream Chanel for AWS service
      DeleteStreamChannelsJob.perform_later(self.id)
    end
    
    def start_in_progress_tracker
      StartInProgressTrackerJob.perform_later(self.id)
    end
    
    def set_failed_status(error_message)
      self.update(status: 'failed', error_message: error_message)
    end
    
    def check_for_status
      if ['completed', 'finished'].exclude?(self.status)
        errors.add(:base, "Cannot delete Stream that not finished")
        throw :abort
      end
    end
end
