require 'rails_helper'

RSpec.describe SquadRequest, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    receiver = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    requestor = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    @squad_request = FactoryBot.create(:squad_request, receiver: receiver, requestor: requestor)
  end
  
  it 'should have a valid factory' do
    receiver = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    requestor = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
    expect(FactoryBot.build(:squad_request, receiver: receiver, requestor: requestor)).to be_valid
  end
  
  context 'associations' do
    it { should belong_to(:receiver).class_name('User').with_foreign_key('receiver_id') }
    it { should belong_to(:requestor).class_name('User').with_foreign_key('requestor_id') }
  end
  
  context 'validations' do
    context 'associations' do
      it { should validate_presence_of(:receiver) }
      it { should validate_presence_of(:requestor) }
      it { should validate_uniqueness_of(:receiver).scoped_to(:requestor_id) }
      it { should validate_uniqueness_of(:requestor).scoped_to(:receiver_id) }
      
      it 'should NOT pass if receiver and requestor is the same User' do
        user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
        expect(FactoryBot.build(:squad_request, receiver: user, requestor: user)).not_to be_valid
      end
    end
  end
end
