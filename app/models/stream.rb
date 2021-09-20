class Stream < ApplicationRecord
  
  # Statuses
  # in-progress - Stream is running on mux.com and awaiting for video from client
  # completed   - Client has successfully ended video streaming, waited for Video file to save, stopped the stream and disabled stream on mux.com
  # finished    - Client is successfully saved stream Video, now it can be show in Stream list (status updated in StreamVideoUploader callback)
  # failed      - Error occurred while AWS services deploying, stream will be stopped, error will be added to object.error_message field, all AWS dependencies will be cleared
  
  # Constants
  STATUS_LIST = %w(in-progress completed finished failed)
  GROUP_TYPES = %w(NewsCategory Topic)
  
  # Callbacks
  before_validation :generate_access_token, on: :create
  after_commit :add_notification
  before_destroy :check_for_status, prepend: true
  
  # File Uploader
  has_one_attached :video
  has_one_attached :image
  
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
  has_many :notifications, as: :source, dependent: :destroy
  
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
  
  def image_url
    self.image.url if self.image.attached?
  end
  
  def video_url
    self.video.url if self.video.attached?
  end
  
  def playback_url
    self.mux_playback_id ? "https://stream.mux.com/#{self.mux_playback_id}.m3u8" : nil
  end
  
  private
    def add_notification
      return if !self.is_private
      CreateNewNotificationsJob.set(wait: 30.seconds).perform_later(self.id, self.class.name)
    end
    
    def generate_access_token
      new_token = SecureRandom.hex(16)
      Stream.exists?(access_token: new_token) ? generate_access_token : self.access_token = new_token
    end
    
    def check_for_status
      if ['completed', 'finished'].exclude?(self.status)
        errors.add(:base, "Cannot delete Stream that's not finished")
        throw :abort
      end
    end
end
