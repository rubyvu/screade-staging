# == Schema Information
#
# Table name: posts
#
#  id                :bigint           not null, primary key
#  comments_count    :integer          default(0), not null
#  description       :text             not null
#  detected_language :string
#  is_approved       :boolean          default(TRUE)
#  is_notification   :boolean          default(TRUE)
#  lits_count        :integer          default(0), not null
#  source_type       :string           not null
#  title             :string           not null
#  views_count       :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  source_id         :integer          not null
#  user_id           :integer          not null
#
# Indexes
#
#  index_posts_on_detected_language  (detected_language)
#
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
    it { is_expected.to have_many(:shared_records) }
    it { is_expected.to have_many(:translations) }
    it { is_expected.to have_many(:views).dependent(:destroy) }
    it { is_expected.to have_many(:viewing_users) }
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
  
  describe 'hooks' do
    it 'is expected to delete :title Translations if :title was changed' do
      post = FactoryBot.create(:post, source: @topic, user: @user)
      language = Language.find_by(code: 'EN')
      title_translation = FactoryBot.create(:translation, language: language, translatable: post, field_name: 'title')
      description_translation = FactoryBot.create(:translation, language: language, translatable: post, field_name: 'description')
      
      expect(post.translations.count).to eq(2)
      
      post.update(title: Faker::Lorem.characters(number: 10))
      
      expect(Translation.find_by(id: title_translation.id)).to eq(nil)
      expect(Translation.find_by(id: description_translation.id)).to eq(description_translation)
    end
    
    it 'is expected to delete :description Translations if :description was changed' do
      post = FactoryBot.create(:post, source: @topic, user: @user)
      language = Language.find_by(code: 'EN')
      title_translation = FactoryBot.create(:translation, language: language, translatable: post, field_name: 'title')
      description_translation = FactoryBot.create(:translation, language: language, translatable: post, field_name: 'description')
      
      expect(post.translations.count).to eq(2)
      
      post.update(description: Faker::Lorem.characters(number: 50))
      
      expect(Translation.find_by(id: title_translation.id)).to eq(title_translation)
      expect(Translation.find_by(id: description_translation.id)).to eq(nil)
    end
  end
end
