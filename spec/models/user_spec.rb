require 'rails_helper'

RSpec.describe User, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:user, country: @country, user_security_question: @user_security_question)).to be_valid
  end
  
  context 'associations' do
    it { should have_many(:devices).class_name('Device').with_foreign_key('owner_id').dependent(:destroy) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:user, country: @country, user_security_question: @user_security_question) }
    
    context 'associations' do
    end
    
    context 'fields' do
      it { should validate_uniqueness_of(:email).case_insensitive }
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:password) }
    end
  end
  
  context 'normalization' do
    it 'should downcase :email' do
      user = FactoryBot.build(:user, email: '  ExaMple@gmail.com ')
      expect(user.email).to eq('example@gmail.com')
    end
    
    it 'should downcase :first_name' do
      user = FactoryBot.build(:user, first_name: '  Darth ')
      expect(user.first_name).to eq('Darth')
    end
    
    it 'should downcase :last_name' do
      user = FactoryBot.build(:user, last_name: '  Vader ')
      expect(user.last_name).to eq('Vader')
    end
  end
end
