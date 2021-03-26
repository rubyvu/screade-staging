require 'rails_helper'

RSpec.describe Device, type: :model do
  before :all do
    country = Country.find_by(code: 'US') || FactoryBot.create(:country)
    user_security_question = FactoryBot.create(:user_security_question)
    @owner = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
  end
  
  after :all do
    # Clear DB
    User.destroy_all
    Device.destroy_all
  end
  
  it 'should have a valid factory' do
    expect(FactoryBot.build(:device, owner: @owner)).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:owner).class_name('User').with_foreign_key('owner_id') }
  end
  
  context 'validations' do
    context 'associations' do
      it { should validate_presence_of(:owner) }
    end
    
    context 'fields' do
      subject { FactoryBot.build(:device, owner: @owner) }
      
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:operational_system) }
      it { should validate_inclusion_of(:operational_system).in_array(Device::OPERATIONAL_SYSTEMS) }
      
      context 'should validate that :access_token cannot be empty/falsy' do
        before { allow(subject).to receive(:access_token).and_return(nil) }
        it { should validate_presence_of(:access_token) }
      end
      
      it 'should validate that :access_token is unique' do
        device = FactoryBot.create(:device, owner: @owner)
        device_1 = FactoryBot.create(:device, owner: @owner)
        device_1.update(access_token: device.access_token)
        expect(device_1.update(access_token: device.access_token)).to eq(false)
      end
    end
  end
  
  context 'callbacks' do
    it 'should generate new :access_token only on creation of Device' do
      device = FactoryBot.create(:device, owner: @owner)
      access_token = device.access_token
      device.update(name: 'any')
      expect(device.access_token).to eq(access_token)
    end
  end
end
