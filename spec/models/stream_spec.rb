require 'rails_helper'

RSpec.describe Stream, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
  end
  
  it 'should have a valid factory' do
    stream = FactoryBot.build(:stream, user: @user)
    expect(stream.present?).to eq(true)
  end
  
  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:stream_comments).dependent(:destroy) }
    it { should have_many(:commenting_users) }
    it { should have_many(:lits).dependent(:destroy) }
    it { should have_many(:liting_users) }
    it { should have_many(:views).dependent(:destroy) }
    it { should have_many(:viewing_users) }
  end
  
  context 'validations' do
    context 'associations' do
      it { should validate_presence_of(:user) }
    end
  
    context 'fields' do
      it { should validate_presence_of(:title) }
    end
  end
end
