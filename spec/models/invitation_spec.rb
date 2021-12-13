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
#  user_id            :bigint
#
# Indexes
#
#  index_invitations_on_invited_by_user_id  (invited_by_user_id)
#  index_invitations_on_user_id             (user_id)
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
    context 'associations' do
    end
    
    context 'fields' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_length_of(:email).is_at_most(100) }
    end
  end
end
