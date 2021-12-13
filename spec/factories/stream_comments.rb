# == Schema Information
#
# Table name: stream_comments
#
#  id         :bigint           not null, primary key
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  stream_id  :integer
#  user_id    :integer
#
# Indexes
#
#  index_stream_comments_on_user_id  (user_id)
#
FactoryBot.define do
  factory :stream_comment do
    message { Faker::Lorem.characters(number: 10) }
  end
end
