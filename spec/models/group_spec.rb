require 'rails_helper'

RSpec.describe Group, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:group)).to be_valid
  end
  
  context 'associations' do
    
  end
  
  context 'validations' do
    subject { FactoryBot.build(:group) }
    
    context 'associations' do
    end
    
    context 'fields' do
      it { should validate_uniqueness_of(:title).case_insensitive }
      it { should validate_presence_of(:title) }
    end
  end
  
  context 'normalization' do
    it 'should downcase :title' do
      user = FactoryBot.build(:group ,title: '  hEalth ')
      expect(user.title).to eq('health')
    end
  end
end
