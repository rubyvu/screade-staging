require 'rails_helper'

RSpec.describe Chat, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:chat)).to be_valid
  end
  
  context 'validations' do
    subject { FactoryBot.build(:chat) }
    
    context 'associations' do
      it { should have_many(:chat_memberships).dependent(:destroy) }
    end
  end
end
