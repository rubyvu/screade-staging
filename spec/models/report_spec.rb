# == Schema Information
#
# Table name: reports
#
#  id               :bigint           not null, primary key
#  details          :text             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  reported_user_id :bigint           not null
#  reporter_user_id :bigint           not null
#
# Indexes
#
#  index_reports_on_reported_user_id  (reported_user_id)
#  index_reports_on_reporter_user_id  (reporter_user_id)
#
require 'rails_helper'

RSpec.describe Report, type: :model do
  before :all do
    country = Country.first || FactoryBot.create(:country)
    user_security_question = FactoryBot.create(:user_security_question)
    @reported = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
    @reporter = FactoryBot.create(:user, country: country, user_security_question: user_security_question)
  end
  
  it 'is expected to have a valid factory' do
    report = FactoryBot.build(:report, reported: @reported, reporter: @reporter)
    expect(report.valid?).to eq(true)
  end
  
  context 'associations' do
    it { is_expected.to belong_to(:reported).with_foreign_key(:reported_user_id).class_name('User').required }
    it { is_expected.to belong_to(:reporter).with_foreign_key(:reporter_user_id).class_name('User').required }
  end
  
  context 'validations' do
    subject { FactoryBot.build(:report, reported: @reported, reporter: @reporter) }
    
    context 'associations' do
    end
    
    context 'fields' do
      it { is_expected.to validate_presence_of(:details) }
    end
  end
end
