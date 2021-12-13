# == Schema Information
#
# Table name: shared_records
#
#  id             :bigint           not null, primary key
#  shareable_type :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sender_id      :bigint           not null
#  shareable_id   :bigint           not null
#
# Indexes
#
#  index_shared_records_on_shareable_id_and_shareable_type  (shareable_id,shareable_type)
#
FactoryBot.define do
  factory :shared_record do
  end
end
