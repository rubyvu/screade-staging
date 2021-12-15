# == Schema Information
#
# Table name: translations
#
#  id                :bigint           not null, primary key
#  field_name        :string           not null
#  result            :text
#  translatable_type :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  language_id       :bigint           not null
#  translatable_id   :bigint           not null
#
# Indexes
#
#  translations_unique_index  (translatable_id,translatable_type,language_id,field_name)
#
require 'rails_helper'

RSpec.describe Translation, type: :model do
  def import_languages
    default_languages = [
      { code: 'AR', title: 'Arabic', countries: ['AE', 'EG', 'MA', 'SA'] },
      { code: 'DE', title: 'German', countries: ['AT', 'BE', 'DE', 'CH', 'IT'] },
      { code: 'EN', title: 'English', countries: ['AU', 'CA', 'US', 'GB', 'HK', 'IE', 'IN', 'KR', 'NG', 'NZ', 'PH', 'SG', 'ZA'] },
      { code: 'ES', title: 'Spanish', countries: ['AR', 'CO', 'CU', 'SE', 'MX', 'VE'] },
      { code: 'FR', title: 'French', countries: ['BE', 'CA', 'CH', 'FR', 'IT', 'MA'] },
      { code: 'HE', title: 'Hebrew', countries: ['IL'] },
      { code: 'IT', title: 'Italian', countries: ['CH', 'IT'] },
      { code: 'NL', title: 'Dutch', countries: ['BE', 'NL'] },
      { code: 'NO', title: 'Norwegian', countries: ['NO', 'SE'] },
      { code: 'PT', title: 'Portuguese', countries: ['BR', 'PT'] },
      { code: 'RU', title: 'Russian', countries: ['RU', 'UA'] },
      { code: 'SE', title: 'Northern Sami', countries: ['NO', 'SE'] },
      { code: 'ZH', title: 'Chinese', countries: ['CN', 'HK', 'TW'] }
    ]
    
    default_languages.each do |language|
      current_language = Language.find_by(code: language[:code])
      current_language = Language.create(code: language[:code], title: language[:title]) unless current_language
      
      language[:countries].each do |country_code|
        next if current_language.countries.pluck(:code).include?(country_code)
        
        country = Country.find_by(code: country_code)
        next unless country
        
        current_language.countries << country
      end
    end
  end
  
  before :all do
    import_languages
    @language = Language.find_by(code: 'EN')
    
    country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    user_security_question = FactoryBot.create(:user_security_question)
    user = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    
    news_category = FactoryBot.create(:news_category)
    topic = FactoryBot.create(:topic, parent: news_category)
    @post = FactoryBot.create(:post, source: topic, user: user)
  end
  
  it 'is expected to have a valid factory' do
    translation = FactoryBot.build(:translation, language: @language, translatable: @post, field_name: 'title')
    expect(translation.valid?).to eq(true)
  end
  
  context 'associations' do
    it { is_expected.to belong_to(:language).required }
    it { is_expected.to belong_to(:translatable).required }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:translation, language: @language, translatable: @post, field_name: 'title') }
    
    context 'associations' do
      it { is_expected.to validate_uniqueness_of(:field_name).scoped_to([:translatable_id, :translatable_type, :language_id]) }
    end
    
    context 'fields' do
      it { is_expected.to validate_presence_of(:field_name) }
    end
  end
end
