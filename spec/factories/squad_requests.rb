# == Schema Information
#
# Table name: squad_requests
#
#  id           :bigint           not null, primary key
#  accepted_at  :datetime
#  declined_at  :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  receiver_id  :integer
#  requestor_id :integer
#
# Indexes
#
#  index_squad_requests_on_receiver_id_and_requestor_id  (receiver_id,requestor_id)
#
FactoryBot.define do
  factory :squad_request do
  end
end
