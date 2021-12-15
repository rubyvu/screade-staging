# == Schema Information
#
# Table name: user_blocks
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  blocked_user_id :bigint           not null
#  blocker_user_id :bigint           not null
#
# Indexes
#
#  index_user_blocks_on_blocker_user_id_and_blocked_user_id  (blocker_user_id,blocked_user_id) UNIQUE
#
require 'rails_helper'

RSpec.describe UserBlock, type: :model do
  before :all do
    country = Country.first || FactoryBot.create(:country)
    user_security_question = FactoryBot.create(:user_security_question)
    @blocked = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    @blocker = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
  end
  
  it 'is expected to have a valid factory' do
    user_block = FactoryBot.build(:user_block, blocked: @blocked, blocker: @blocker)
    expect(user_block.valid?).to eq(true)
  end
  
  context 'associations' do
    it { is_expected.to belong_to(:blocked).with_foreign_key(:blocked_user_id).class_name('User').required }
    it { is_expected.to belong_to(:blocker).with_foreign_key(:blocker_user_id).class_name('User').required }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:user_block, blocked: @blocked, blocker: @blocker) }
    
    context 'associations' do
      it { is_expected.to validate_uniqueness_of(:blocker_user_id).scoped_to(:blocked_user_id) }
    end
    
    context 'fields' do
    end
  end
end
