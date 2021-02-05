# Create Countries in DB
countries_with_national_news = Country::COUNTRIES_WITH_NATIONAL_NEWS
CS.countries.map do |code, title|
  code = code.to_s
  next if Country.exists?(code: code, title: title)
  
  current_country = Country.find_by(code: code)
  if current_country
    current_country.update_columns(title: title)
  else
    current_country = Country.create(code: code, title: title)
  end
  
  current_country.update_columns(is_national_news: true) if countries_with_national_news.include?(current_country.code)
end
