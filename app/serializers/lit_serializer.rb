# == Schema Information
#
# Table name: lits
#
#  id          :bigint           not null, primary key
#  source_type :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  source_id   :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_lits_on_source_id_and_source_type_and_user_id  (source_id,source_type,user_id) UNIQUE
#
class LitSerializer < ActiveModel::Serializer
  attribute :id
  
  attribute :user
  def user
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.user, current_user: current_user).as_json
  end
end
