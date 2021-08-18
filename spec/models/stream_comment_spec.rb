require 'rails_helper'

RSpec.describe StreamComment, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @stream = FactoryBot.build(:stream, owner: @user)
  end
  
  it 'should have a valid factory' do
    stream_comment = FactoryBot.build(:stream_comment, stream: @stream, user: @user)
    expect(stream_comment.present?).to eq(true)
  end
  
  context 'associations' do
    it { should belong_to(:stream) }
    it { should belong_to(:user) }
  end
  
  context 'validations' do
    context 'associations' do
      it { should validate_presence_of(:stream) }
      it { should validate_presence_of(:user) }
    end
  
    context 'fields' do
      it { should validate_presence_of(:message) }
    end
  end
end
