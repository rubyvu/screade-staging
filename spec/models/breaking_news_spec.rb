# == Schema Information
#
# Table name: breaking_news
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#
require 'rails_helper'

RSpec.describe BreakingNews, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:breaking_news)).to be_valid
  end
  
  context 'validations' do
    subject { FactoryBot.build(:breaking_news) }
  end
  
  context 'callbacks' do
    context 'is_active should be unique' do
      after :each do
        BreakingNews.destroy_all
      end
    end
  end
end
