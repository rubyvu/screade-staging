class Stream < ApplicationRecord
  
  # Constants
  STATUS_LIST = %w(pending in-progress completed finished faild)
  GROUP_TYPES = %w(NewsCategory Topic)
  VIDEO_RESOLUTIONS = %w(mp4)
  
  # Callbacks
  before_validation :generate_access_token, on: :create
  after_commit :create_aws_media, on: :create
  after_commit :remove_aws_media, on: :update
  # after_save :add_notification
  
  # File Uploader
  mount_uploader :image, StreamImageUploader
  mount_uploader :video, StreamVideoUploader
  
  # Associations
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  belongs_to :group, polymorphic: true, optional: true
  has_and_belongs_to_many :users
  has_and_belongs_to_many :news_categories
  
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
        set_faild_status('Input security group cannot be created.')
        return
      end
      
      puts "===== 1 Security group created"
      channel_input_to_attach = Tasks::AwsMediaLiveApi.create_input(self.access_token, input_security_group)
      if input_security_group.blank?
        set_faild_status('Channel Input cannot be created.')
        return
      end
      
      puts "===== 2 Input channel created"
      channel = Tasks::AwsMediaLiveApi.create_channel(self.access_token, channel_input_to_attach)
      if channel.blank?
        set_faild_status('Channel cannot be created.')
        return
      end
      
      puts "===== 3 GET channel ID and input ID"
      channel_id = channel.id
      channel_input_id = channel['input_attachments'][0]['input_id']
      if channel_input_id.blank?
        set_faild_status('Channel ID should be present.')
        return
      end
      
      puts "===== 4 GET RTMP URL"
      input_rtmp_url = Tasks::AwsMediaLiveApi.get_input_url(channel_input_id.to_s)
      if input_rtmp_url.blank?
        set_faild_status('Input attachments should be present.')
        #TODO: clear AWS Media, inputs, secure groups
        return
      end
      
      puts "===== 5 Done"
      # Save chanel data
      aws_channel_params = {
        channel_id: channel_id,
        channel_input_id: channel_input_id,
        rtmp_url: input_rtmp_url,
        stream_url: "https://#{ENV['AWS_STREAM_CLOUD_FRONT_DOMAIN_NAME']}/#{self.access_token}/index.m3u8"
      }
      self.update_columns(aws_channel_params)
      
      # Start Stream Chanel
      StartStreamChannelsJob.perform_later(self.id)
    end
    
    def remove_aws_media
      return if ['faild', 'finished'].exclude?(self.status)
      # Delete input group, attached group, chanel media store items from AWS services
    end
    
    def set_faild_status(error_message)
      self.update(status: 'faild', error_message: error_message)
    end
end
