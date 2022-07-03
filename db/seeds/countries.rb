# Create Countries in DB
countries_with_national_news = Country::COUNTRIES_WITH_NATIONAL_NEWS
CS.countries.map do |code, title|
  next if code.length > 2
  
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

# Create and Assign Languages
default_languages = [
  { code: 'AR', title: 'Arabic', countries: ['AE', 'EG', 'MA', 'SA'] },
  { code: 'DE', title: 'German', countries: ['AT', 'BE', 'DE', 'CH', 'IT'] },
  { code: 'EN', title: 'English', countries: ['AU', 'CA', 'US', 'GB', 'HK', 'IE', 'IN', 'KR', 'NG', 'NZ', 'PH', 'SG', 'ZA'] },
  { code: 'ES', title: 'Spanish', countries: ['AR', 'CO', 'CU', 'SE', 'MX', 'VE'] },
  { code: 'FR', title: 'French', countries: ['BE', 'CA', 'CH', 'FR', 'IT', 'MA'] },
  { code: 'HE', title: 'Hebrew', countries: ['IL'] },
  { code: 'IT', title: 'Italian', countries: ['CH', 'IT'] },
  { code: 'NL', title: 'Dutch', countries: ['BE', 'NL'] },
  { code: 'NO', title: 'Norwegian', countries: ['NO', 'SE'] },
  { code: 'PT', title: 'Portuguese', countries: ['BR', 'PT'] },
  { code: 'RU', title: 'Russian', countries: ['RU', 'UA'] },
  { code: 'UK', title: 'Ukrainian', countries: ['UA'] },
  { code: 'SE', title: 'Northern Sami', countries: ['NO', 'SE'] },
  { code: 'ZH', title: 'Chinese', countries: ['CN', 'HK', 'TW'] }
]

default_languages.each do |language|
  current_language = Language.find_by(code: language[:code])
  current_language = Language.create(code: language[:code], title: language[:title]) unless current_language
  
  language[:countries].each do |country_code|
    next if current_language.countries.pluck(:code).include?(country_code)
    
    country = Country.find_by(code: country_code)
    next unless country
      
    current_language.countries << country
  end
end

# Set English as default laguage for Countries without languages
english_language = Language.find_by(code: 'EN')
Country.joins("LEFT JOIN countries_languages ON countries.id = countries_languages.country_id").where("countries_languages.country_id IS NULL").each do |country|
  next if country.languages.count > 0
  country.languages << english_language
end
