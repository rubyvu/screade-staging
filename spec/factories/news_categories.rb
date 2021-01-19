FactoryBot.define do
  factory :news_category do
    title { NewsCategory::DEFAULT_CATEGORIES.sample }
  end
end
