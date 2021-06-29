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
    post = FactoryBot.build(:post, source: @topic, user: @user)
    expect(post.present?).to eq(true)
  end
  
  context 'associations' do
    it { should belong_to(:source) }
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:commenting_users) }
    it { should have_many(:lits).dependent(:destroy) }
    it { should have_many(:liting_users) }
    it { should have_many(:post_groups) }
    it { should have_many(:views).dependent(:destroy) }
    it { should have_many(:viewing_users) }
  end
  
  context 'validations' do
    context 'associations' do
      it { should validate_presence_of(:user) }
    end
  
    context 'fields' do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:source_id) }
      it { should validate_presence_of(:source_type) }
      it { should validate_inclusion_of(:source_type).in_array(Post::SOURCE_TYPES) }
    end
  end
  
end
