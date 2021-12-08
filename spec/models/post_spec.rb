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
    it { is_expected.to belong_to(:source) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:commenting_users) }
    it { is_expected.to have_many(:lits).dependent(:destroy) }
    it { is_expected.to have_many(:liting_users) }
    it { is_expected.to have_many(:post_groups) }
    it { is_expected.to have_many(:views).dependent(:destroy) }
    it { is_expected.to have_many(:viewing_users) }
    it { is_expected.to have_many(:shared_records) }
  end
  
  context 'validations' do
    context 'associations' do
      it { is_expected.to validate_presence_of(:user) }
    end
    
    context 'fields' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:source_id) }
      it { is_expected.to validate_presence_of(:source_type) }
      it { is_expected.to validate_inclusion_of(:source_type).in_array(Post::SOURCE_TYPES) }
    end
  end
end
