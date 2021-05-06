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
      it { should belong_to(:country) }
      it { should belong_to(:user_security_question) }
      it { should have_one(:setting).dependent(:destroy) }
      it { should have_many(:devices).dependent(:destroy) }
      it { should have_many(:events).dependent(:destroy) }
      it { should have_many(:squad_requests_as_receiver).dependent(:destroy) }
      it { should have_many(:squad_requests_as_requestor).dependent(:destroy) }
      it { should have_many(:comments).dependent(:destroy) }
      it { should have_many(:commented_news_articles) }
      it { should have_many(:lits).dependent(:destroy) }
      it { should have_many(:lited_news_articles) }
      it { should have_many(:views).dependent(:destroy) }
      it { should have_many(:viewed_news_articles) }
      it { should have_many(:suggested_topics).dependent(:nullify) }
      it { should have_many(:user_images).dependent(:destroy) }
      it { should have_many(:user_videos).dependent(:destroy) }
      it { should have_and_belong_to_many(:languages) }
    end
    
    context 'fields' do
      it { should validate_uniqueness_of(:email).case_insensitive }
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:password) }
      it { should validate_presence_of(:security_question_answer) }
      it { should validate_presence_of(:username) }
      it { should validate_presence_of(:user_security_question_id) }
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
