# == Schema Information
#
# Table name: users
#
#  id                        :bigint           not null, primary key
#  allow_direct_messages     :boolean          default(TRUE)
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
class UserSerializer < ActiveModel::Serializer
  
  attribute :allow_direct_messages
  
  attribute :banner_picture
  def banner_picture
    object&.banner_picture_url
  end
  
  attribute :birthday
  def birthday
    object&.birthday&.strftime('%Y-%m-%d')
  end
  
  attribute :country_code
  def country_code
    object&.country.code
  end
  
  attribute :comments_count
  def comments_count
    object&.comments_count
  end
  
  attribute :email
  attribute :first_name
  attribute :id
  
  attribute :is_confirmed
  def is_confirmed
    object&.confirmed? || false
  end
  
  attribute :last_name
  attribute :languages
  def languages
    ActiveModel::Serializer::CollectionSerializer.new(object.languages, serializer: LanguageSerializer).as_json
  end
  
  attribute :lits_count
  def lits_count
    object&.lits_count
  end
  
  attribute :middle_name
  attribute :phone_number
  
  attribute :profile_picture
  def profile_picture
    object.profile_picture_url
  end
  
  attribute :show_invitation_popup
  def show_invitation_popup
    return false if object.hide_invitation_popup
    
    object.created_at <= 7.days.ago
  end
  
  attribute :squad_members_count
  def squad_members_count
    object.count_squad_members
  end
  
  attribute :squad_requests_count
  def squad_requests_count
    object.count_squad_requests
  end
  
  attribute :views_count
  def views_count
    object&.views_count
  end
  
  attribute :username
end
