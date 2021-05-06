class TopicSerializer < ActiveModel::Serializer
  attribute :id
  attribute :nesting_position
  attribute :title
  attribute :is_assigned
  def is_assigned
    # TODO: check if user assigned to this topic
    false
  end
end
