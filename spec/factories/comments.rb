# == Schema Information
#
# Table name: comments
#
#  id          :bigint           not null, primary key
#  lits_count  :integer          default(0), not null
#  message     :text
#  source_type :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  comment_id  :integer
#  source_id   :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_comments_on_source_id  (source_id)
#
FactoryBot.define do
  factory :comment do
    message { Faker::Lorem.characters(number: 30) }
  end
end
