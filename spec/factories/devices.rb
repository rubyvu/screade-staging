# == Schema Information
#
# Table name: devices
#
#  id                 :bigint           not null, primary key
#  access_token       :string           not null
#  name               :string
#  operational_system :string           not null
#  push_token         :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  owner_id           :integer          not null
#
# Indexes
#
#  index_devices_on_access_token  (access_token) UNIQUE
#  index_devices_on_owner_id      (owner_id)
#  index_devices_on_push_token    (push_token)
#
FactoryBot.define do
  factory :device do
    name { Faker::Lorem.characters(number: 10) }
    operational_system { Device::OPERATIONAL_SYSTEMS.sample }
  end
end
