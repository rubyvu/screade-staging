# == Schema Information
#
# Table name: post_groups
#
#  id         :bigint           not null, primary key
#  group_type :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer          not null
#  post_id    :integer          not null
#
# Indexes
#
#  index_post_groups_on_post_id  (post_id)
#
class PostGroupSerializer < ActiveModel::Serializer
  attribute :type
  def type
    object.class.name
  end
  
  attribute :id
  attribute :title
  attribute :image
  def image
    object.class.name == 'NewsCategory' ? object.image.url : nil
  end
  
  attribute :parent_type
  def parent_type
    if object.class.name == 'Topic'
      object.parent_type
    else
      nil
    end
  end
  
  attribute :parent_id
  def parent_id
    if object.class.name == 'Topic'
      object.parent_id
    else
      nil
    end
  end
  
  attribute :nesting_position
  def nesting_position
    if object.class.name == 'Topic'
      object.nesting_position+1
    else
      0
    end
  end
end
