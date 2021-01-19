FactoryBot.define do
  factory :group do
    title { Group::DEFAULT_GROUPS.sample }
  end
end
