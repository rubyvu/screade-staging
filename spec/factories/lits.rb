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
FactoryBot.define do
  factory :lit do
  end
end
