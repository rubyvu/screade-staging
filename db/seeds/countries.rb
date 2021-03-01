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

# Create and Assign Languages
default_languages = [
  { code: 'AR', title: 'Arabic', countries: ['AR'] },
  { code: 'DE', title: 'German', countries: ['DE'] },
  { code: 'EN', title: 'English', countries: ['CA', 'US', 'UK'] },
  { code: 'ES', title: 'Spanish', countries: ['SE'] },
  { code: 'FR', title: 'French', countries: ['CA', 'FR'] },
  { code: 'HE', title: 'Hebrew', countries: ['IL'] },
  { code: 'IT', title: 'Italian', countries: ['IT'] },
  { code: 'NL', title: 'Dutch', countries: ['NL'] },
  { code: 'NO', title: 'Norwegian', countries: ['NO', 'SE'] },
  { code: 'PT', title: 'Portuguese', countries: ['PT'] },
  { code: 'RU', title: 'Russian', countries: ['RU', 'UA'] },
  { code: 'SE', title: 'Northern Sami', countries: ['NO', 'SE'] },
  { code: 'ZH', title: 'Chinese', countries: ['CN'] }
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
