# == Schema Information
#
# Table name: users
#
#  id                        :bigint           not null, primary key
#  birthday                  :date
#  blocked_at                :datetime
#  blocked_comment           :string
#  confirmation_sent_at      :datetime
#  confirmation_token        :string
#  confirmed_at              :datetime
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  failed_attempts           :integer          default(0), not null
#  first_name                :string
#  hide_invitation_popup     :boolean          default(FALSE)
#  last_name                 :string
#  locked_at                 :datetime
#  middle_name               :string
#  phone_number              :string
#  remember_created_at       :datetime
#  reset_password_sent_at    :datetime
#  reset_password_token      :string
#  security_question_answer  :string           not null
#  unconfirmed_email         :string
#  username                  :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  country_id                :integer          not null
#  invited_by_user_id        :bigint
#  user_security_question_id :integer          not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Lorem.characters(number: 18) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Lorem.characters(number: 20) }
    security_question_answer { Faker::Lorem.characters(number: 20) }
  end
end
