class StreamComment < ApplicationRecord
  
  # Callbacks
  after_commit :broadcast_new_comment, on: :create
  
  # Associations
  belongs_to :stream
  belongs_to :user
  
  # Associations validations
  validates :stream, presence: true
  validates :user, presence: true
  
  # Field validations
  validates :message, presence: true
  
  private
  def broadcast_new_comment
    render_stream_comment_template = ApplicationController.renderer.render(partial: 'stream_comments/show', locals: { comment: self })
    ActionCable.server.broadcast "new_stream_#{self.stream.id}_comment_channel", stream_comment_json: StreamCommentSerializer.new(self, current_user: self.user).as_json, stream_comment_html: render_stream_comment_template
  end
end
