FactoryBot.define do
  factory :device do
    name { Faker::Lorem.characters(number: 10) }
    operational_system { Device::OPERATIONAL_SYSTEMS.sample }
  end
end
