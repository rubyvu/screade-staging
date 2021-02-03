NewsCategory::DEFAULT_CATEGORIES.each do |category_title|
  NewsCategory.create_or_find_by(title: category_title)
end
