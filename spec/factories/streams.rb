# == Schema Information
#
# Table name: streams
#
#  id                    :bigint           not null, primary key
#  access_token          :string           not null
#  error_message         :string
#  group_type            :string
#  is_private            :boolean          default(TRUE), not null
#  lits_count            :integer          default(0), not null
#  mux_stream_key        :string
#  status                :string           default("in-progress"), not null
#  stream_comments_count :integer          default(0), not null
#  title                 :string           not null
#  views_count           :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  group_id              :integer
#  mux_playback_id       :string
#  mux_stream_id         :string
#  user_id               :integer          not null
#
# Indexes
#
#  index_streams_on_status   (status)
#  index_streams_on_user_id  (user_id)
#
FactoryBot.define do
  factory :stream do
    title { Faker::Lorem.characters(number: 10) }
  end
end
