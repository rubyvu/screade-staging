export function isTwelveHoursFormat() {
  const countriesWithTwelveHoursFormat = ['AU', 'BD', 'CA', 'CO', 'EG', 'SV', 'HN', 'IN', 'IE', 'JO', 'MY', 'MX', 'NZ', 'NI', 'PK', 'PH', 'SA', 'US']
  let currentLocation = 'US'
  
  let currentLocationMatch = document.cookie.match(new RegExp('(^| )' + 'current_location' + '=([^;]+)'));
  if (currentLocationMatch) currentLocation = currentLocationMatch[2]
  
  return countriesWithTwelveHoursFormat.includes(currentLocation)
}
