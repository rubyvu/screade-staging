require 'rails_helper'

RSpec.describe Event, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user = FactoryBot.build(:user, country: @country, user_security_question: @user_security_question)
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:event, user: @user)).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:user) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:event, user: @user) }
    
    context 'associations' do
      it { should validate_presence_of(:user) }
    end
    
    context 'fields' do
      it { should validate_presence_of(:date) }
      it { should validate_presence_of(:end_date) }
      it { should validate_presence_of(:start_time) }
      it { should validate_presence_of(:title) }
    end
  end
end
