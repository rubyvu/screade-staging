# == Schema Information
#
# Table name: invitations
#
#  id                 :bigint           not null, primary key
#  email              :string           not null
#  token              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  invited_by_user_id :bigint           not null
#
# Indexes
#
#  index_invitations_on_invited_by_user_id  (invited_by_user_id)
#  index_invitations_on_token               (token) UNIQUE
#
require 'rails_helper'

RSpec.describe Invitation, type: :model do
  before :all do
    country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    user_security_question = FactoryBot.create(:user_security_question)
    @invited_by = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
  end
  
  it 'is expected to have a valid factory' do
    invitation = FactoryBot.build(:invitation, invited_by_user: @invited_by)
    expect(invitation.valid?).to eq(true)
  end
  
  context 'associations' do
    it { is_expected.to belong_to(:invited_by_user).with_foreign_key(:invited_by_user_id).class_name('User').required }
  end
  
  context 'validations' do
    subject { FactoryBot.create(:invitation, invited_by_user: @invited_by) }
    
    context 'associations' do
    end
    
    context 'fields' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_length_of(:email).is_at_most(100) }
      it { is_expected.to validate_presence_of(:token) }
      
      it 'is expected to validate uniqueness of :token' do
        invitation1 = FactoryBot.create(:invitation, invited_by_user: @invited_by)
        invitation2 = FactoryBot.create(:invitation, invited_by_user: @invited_by)
        invitation2.token = invitation1.token
        expect(invitation2.valid?).to eq(false)
      end
    end
  end
  
  context 'callbacks' do
    it 'should generate new :token on #create' do
      invitation = FactoryBot.create(:invitation, invited_by_user: @invited_by)
      expect(invitation.token).not_to be_empty
    end
  end
end
