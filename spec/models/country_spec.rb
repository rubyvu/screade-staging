# == Schema Information
#
# Table name: countries
#
#  id               :bigint           not null, primary key
#  code             :string           not null
#  is_national_news :boolean          default(FALSE)
#  title            :string           not null
#
# Indexes
#
#  index_countries_on_code  (code) UNIQUE
#
require 'rails_helper'

RSpec.describe Country, type: :model do
  it 'should have a valid factory' do
    Country.destroy_all
    expect(FactoryBot.build(:country)).to be_valid
  end
  
  context 'associations' do
    it { should have_many(:news_articles).class_name('NewsArticle') }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:country) }
    
    context 'associations' do
    end
    
    context 'fields' do
      it { should validate_presence_of(:title) }
      it { should validate_uniqueness_of(:code).case_insensitive }
      it { should validate_presence_of(:code) }
    end
  end
end
