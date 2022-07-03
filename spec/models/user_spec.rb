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
require 'rails_helper'

RSpec.describe User, type: :model do
  before :all do
    @country = Country.first || FactoryBot.create(:country)
    @user_security_question = FactoryBot.create(:user_security_question)
  end
  
  it 'is expected to have a valid factory' do
    user = FactoryBot.build(:user, country: @country, user_security_question: @user_security_question)
    expect(user.valid?).to eq(true)
  end
  
  context 'associations' do
    it { is_expected.to have_many(:devices).class_name('Device').with_foreign_key(:owner_id).dependent(:destroy) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:user, country: @country, user_security_question: @user_security_question) }
    
    context 'associations' do
      it { is_expected.to belong_to(:country) }
      it { is_expected.to belong_to(:user_security_question) }
      it { is_expected.to have_one(:setting).dependent(:destroy) }
      it { is_expected.to have_many(:devices).dependent(:destroy) }
      it { is_expected.to have_many(:events).dependent(:destroy) }
      it { is_expected.to have_many(:squad_requests_as_receiver).dependent(:destroy) }
      it { is_expected.to have_many(:squad_requests_as_requestor).dependent(:destroy) }
      it { is_expected.to have_many(:comments).dependent(:destroy) }
      it { is_expected.to have_many(:commented_news_articles) }
      it { is_expected.to have_many(:invitations).with_foreign_key(:invited_by_user_id).class_name('Invitation').dependent(:destroy) }
      it { is_expected.to belong_to(:invited_by_user).with_foreign_key(:invited_by_user_id).class_name('User').optional }
      it { is_expected.to have_many(:lits).dependent(:destroy) }
      it { is_expected.to have_many(:lited_news_articles) }
      it { is_expected.to have_many(:reports_as_reported).with_foreign_key(:reported_user_id).class_name('Report').dependent(:nullify) }
      it { is_expected.to have_many(:reports_as_reporter).with_foreign_key(:reporter_user_id).class_name('Report').dependent(:nullify) }
      it { is_expected.to have_many(:views).dependent(:destroy) }
      it { is_expected.to have_many(:viewed_news_articles) }
      it { is_expected.to have_many(:sent_shared_records).with_foreign_key(:sender_id).class_name('SharedRecord').dependent(:destroy) }
      it { is_expected.to have_many(:suggested_topics).dependent(:nullify) }
      it { is_expected.to have_many(:user_blocks_as_blocked).with_foreign_key(:blocked_user_id).class_name('UserBlock').dependent(:destroy) }
      it { is_expected.to have_many(:user_blocks_as_blocker).with_foreign_key(:blocker_user_id).class_name('UserBlock').dependent(:destroy) }
      it { is_expected.to have_many(:user_images).dependent(:destroy) }
      it { is_expected.to have_many(:user_videos).dependent(:destroy) }
      it { is_expected.to have_and_belong_to_many(:languages) }
    end
    
    context 'fields' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_length_of(:email).is_at_most(100) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_presence_of(:security_question_answer) }
      it { is_expected.to validate_presence_of(:username) }
      it { is_expected.to validate_presence_of(:user_security_question_id) }
    end
  end
  
  context 'callbacks' do
    it 'is expected to create SquadRequest' do
      user1 = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
      user2 = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question, invited_by_user: user1)
      
      squad_request = SquadRequest.find_by(requestor: user1, receiver: user2)
      expect(squad_request).not_to eq(nil)
      expect(squad_request.accepted_at).not_to eq(nil)
      expect(squad_request.declined_at).to eq(nil)
    end
  end
  
  context 'normalization' do
    it 'is expected to downcase and cleanup :email' do
      user = FactoryBot.build(:user, email: '  ExaMple@gmail.com ')
      expect(user.email).to eq('example@gmail.com')
    end
    
    it 'is expected to capitalize and cleanup :first_name' do
      user = FactoryBot.build(:user, first_name: '  Darth ')
      expect(user.first_name).to eq('Darth')
    end
    
    it 'is expected to capitalize and cleanup :last_name' do
      user = FactoryBot.build(:user, last_name: '  Vader ')
      expect(user.last_name).to eq('Vader')
    end
  end
end
