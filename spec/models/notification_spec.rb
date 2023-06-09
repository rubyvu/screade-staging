# == Schema Information
#
# Table name: notifications
#
#  id           :bigint           not null, primary key
#  is_shared    :boolean          default(FALSE)
#  is_viewed    :boolean          default(FALSE)
#  message      :string           not null
#  source_type  :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :integer          not null
#  sender_id    :integer
#  source_id    :integer          not null
#
# Indexes
#
#  index_notifications_on_recipient_id  (recipient_id)
#
require 'rails_helper'

RSpec.describe Notification, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @source_user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
  end
  
  it 'should have a valid factory' do
    notification = FactoryBot.build(:notification, source: @source_user, recipient: @user)
    expect(notification.present?).to eq(true)
  end
  
  context 'associations' do
    it { should belong_to(:source) }
    it { should belong_to(:recipient) }
  end
  
  context 'validations' do
    context 'associations' do
      it { should validate_presence_of(:recipient) }
    end
  
    context 'fields' do
      it { should validate_presence_of(:message) }
      it { should validate_presence_of(:source_id) }
      it { should validate_presence_of(:source_type) }
      it { should validate_inclusion_of(:source_type).in_array(Notification::SOURCE_TYPES) }
    end
  end
end
