# Create Countries in DB
countries = [
  { title: 'United Arab Emirates', code: 'ae' },
  { title: 'Argentina', code: 'ar' },
  { title: 'Austria', code: 'at' },
  { title: 'Australia', code: 'au' },
  { title: 'Belgium', code: 'be' },
  { title: 'Bulgaria', code: 'bg' },
  { title: 'Brazil', code: 'br' },
  { title: 'Canada', code: 'ca' },
  { title: 'Switzerland', code: 'ch' },
  { title: 'China', code: 'cn' },
  { title: 'Colombia', code: 'co' },
  { title: 'Cuba', code: 'cu' },
  { title: 'Czech Republic', code: 'cz' },
  { title: 'Germany', code: 'de' },
  { title: 'Egypt', code: 'eg' },
  { title: 'France', code: 'fr' },
  { title: 'United Kingdom', code: 'gb' },
  { title: 'Greece', code: 'gr' },
  { title: 'Hong Kong', code: 'hk' },
  { title: 'Hungary', code: 'hu' },
  { title: 'Indonesia', code: 'id' },
  { title: 'Ireland', code: 'ie' },
  { title: 'Israel', code: 'il' },
  { title: 'India', code: 'in' },
  { title: 'Italy', code: 'it' },
  { title: 'Japan', code: 'jp' },
  { title: 'South Korea', code: 'kr' },
  { title: 'Lithuania', code: 'lt' },
  { title: 'Latvia', code: 'lv' },
  { title: 'Morocco', code: 'ma' },
  { title: 'Mexico', code: 'mx' },
  { title: 'Malaysia', code: 'my' },
  { title: 'Nigeria', code: 'ng' },
  { title: 'Netherlands', code: 'nl' },
  { title: 'Norway', code: 'no' },
  { title: 'New Zealand', code: 'nz' },
  { title: 'Philippines', code: 'ph' },
  { title: 'Poland', code: 'pl' },
  { title: 'Portugal', code: 'pt' },
  { title: 'Romania', code: 'ro' },
  { title: 'Serbia', code: 'rs' },
  { title: 'Russia', code: 'ru' },
  { title: 'Saudi Arabia', code: 'sa' },
  { title: 'Sweden', code: 'se' },
  { title: 'Singapore', code: 'sg' },
  { title: 'Slovenia', code: 'si' },
  { title: 'Slovakia', code: 'sk' },
  { title: 'Thailand', code: 'th' },
  { title: 'Turkey', code: 'tr' },
  { title: 'Taiwan', code: 'tw' },
  { title: 'Ukraine', code: 'ua' },
  { title: 'United States', code: 'us' },
  { title: 'Venezuela', code: 've' },
  { title: 'South Africa', code: 'za' }
]

countries.each do |country_params|
  next if Country.exists?(country_params)
  
  current_country = Country.find_by(code: country_params[:code])
  if current_country
    current_country.update_columns(title: country_params[:title])
  else
    Country.create(country_params)
  end
end
