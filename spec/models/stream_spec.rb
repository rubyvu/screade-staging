# == Schema Information
#
# Table name: streams
#
#  id                    :bigint           not null, primary key
#  access_token          :string           not null
#  error_message         :string
#  group_type            :string
#  is_private            :boolean          default(TRUE), not null
#  lits_count            :integer          default(0), not null
#  mux_stream_key        :string
#  status                :string           default("in-progress"), not null
#  stream_comments_count :integer          default(0), not null
#  title                 :string           not null
#  views_count           :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  group_id              :integer
#  mux_playback_id       :string
#  mux_stream_id         :string
#  user_id               :integer          not null
#
# Indexes
#
#  index_streams_on_status   (status)
#  index_streams_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Stream, type: :model do
  before :all do
    @country = Country.find_by(code: 'US') || FactoryBot.create(:country, code: 'US')
    @user_security_question = FactoryBot.create(:user_security_question)
    @user = FactoryBot.create(:user, country: @country, user_security_question: @user_security_question)
  end
  
  it 'should have a valid factory' do
    stream = FactoryBot.build(:stream, owner: @user)
    expect(stream.present?).to eq(true)
  end
  
  context 'associations' do
    it { should belong_to(:owner) }
    it { should have_many(:stream_comments).dependent(:destroy) }
    it { should have_many(:commenting_users) }
    it { should have_many(:lits).dependent(:destroy) }
    it { should have_many(:liting_users) }
    it { should have_many(:views).dependent(:destroy) }
    it { should have_many(:viewing_users) }
  end
  
  context 'validations' do
    context 'associations' do
      it { should validate_presence_of(:owner) }
    end
  
    context 'fields' do
      it { should validate_presence_of(:title) }
    end
  end
end
