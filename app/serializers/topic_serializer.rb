# == Schema Information
#
# Table name: topics
#
#  id               :bigint           not null, primary key
#  is_approved      :boolean          default(TRUE)
#  nesting_position :integer          not null
#  parent_type      :string           not null
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  parent_id        :integer          not null
#  suggester_id     :integer
#
# Indexes
#
#  index_topics_on_parent_id  (parent_id)
#
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
