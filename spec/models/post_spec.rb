require 'rails_helper'

RSpec.describe Post, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @news_category = FactoryBot.create(:news_category)
    @topic = FactoryBot.create(:topic, parent: @news_category)
  end
  
  it 'should have a valid factory' do
    post = FactoryBot.build(:post, news_category: @news_category, topic: @topic, user: @user)
    expect(post.present?).to eq(true)
  end
  
  context 'associations' do
    subject { FactoryBot.build(:post, news_category: @news_category, topic: @topic, user: @user) }
    it { should belong_to(:news_category) }
    it { should belong_to(:topic) }
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:commenting_users) }
    it { should have_many(:lits).dependent(:destroy) }
    it { should have_many(:liting_users) }
    it { should have_many(:views).dependent(:destroy) }
    it { should have_many(:viewing_users) }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:post, news_category: @news_category, topic: @topic, user: @user) }
    
    context 'associations' do
      it { should validate_presence_of(:news_category) }
      it { should validate_presence_of(:topic) }
      it { should validate_presence_of(:user) }
    end
  
    context 'fields' do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:state) }
      it { should validate_inclusion_of(:state).in_array(Post::APPROVING_STATES) }
    end
  end
  
end
