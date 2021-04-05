require 'rails_helper'

RSpec.describe Contact, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:contact)).to be_valid
  end
  
  context 'validations' do
    subject { FactoryBot.build(:contact) }
    
    context 'fields' do
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:message) }
      it { should validate_presence_of(:subject) }
      it { should validate_presence_of(:username) }
    end
  end
end
