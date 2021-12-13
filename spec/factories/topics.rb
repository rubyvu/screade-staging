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
FactoryBot.define do
  factory :topic do
    title { Faker::Lorem.characters(number: 10) }
    is_approved { false }
  end
end
