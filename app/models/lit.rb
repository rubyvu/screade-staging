class Lit < ApplicationRecord
  
  SOURCE_TYPES = %w(NewsArticle Comment Post Stream)
  
  # Callbacks
  after_commit :broadcast_stream_info
  
  # Associations
  belongs_to :source, polymorphic: true, counter_cache: :lits_count
  belongs_to :user
  
  # Field validations
  validates :source_id, presence: true, uniqueness: { scope: [:source_type, :user_id] }
  validates :source_type, presence: true, inclusion: { in: Lit::SOURCE_TYPES }
  validates :user_id, presence: true, uniqueness: { scope: [:source_type, :source_id] }
  
  private
    # Broadcast Chat State
    def broadcast_stream_info
      return if self.source_type != 'Stream'
      ActionCable.server.broadcast "stream_info_#{self.source.access_token}_channel", stream_info_json: StreamInfoSerializer.new(self.source).as_json
    end
end
