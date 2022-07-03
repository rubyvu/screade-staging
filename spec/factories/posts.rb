# == Schema Information
#
# Table name: posts
#
#  id                :bigint           not null, primary key
#  comments_count    :integer          default(0), not null
#  description       :text             not null
#  detected_language :string
#  is_approved       :boolean          default(TRUE)
#  is_notification   :boolean          default(TRUE)
#  lits_count        :integer          default(0), not null
#  source_type       :string           not null
#  title             :string           not null
#  views_count       :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  source_id         :integer          not null
#  user_id           :integer          not null
#
# Indexes
#
#  index_posts_on_detected_language  (detected_language)
#
FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number: 10) }
    description { Faker::Lorem.characters(number: 50) }
  end
end
