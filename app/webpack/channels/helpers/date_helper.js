export function chat_date(date){
  let currentDate = parseDate(date)
  
  if (!isTwelveHoursFormat()) {
    // dd.mm.yyyy
    return roundUpNumber(currentDate.getDate()) + '.' + roundUpNumber(currentDate.getMonth() + 1) + '.' + currentDate.getFullYear()
  } else {
    // mm/dd/yyy
    return roundUpNumber(currentDate.getMonth() + 1) + '/' + roundUpNumber(currentDate.getDate()) + '/' + currentDate.getFullYear()
  }
}

export function chat_time(date) {
  let currentDate = parseDate(date)
  
  if (!isTwelveHoursFormat()) {
    // dd.mm.yyyy
    return new Intl.DateTimeFormat('default', { hour12: false, hour: 'numeric', minute: 'numeric' }).format(currentDate);
  } else {
    // mm/dd/yyy
    return new Intl.DateTimeFormat('default', { hour12: true, hour: 'numeric', minute: 'numeric' }).format(currentDate).toUpperCase();
  }
}

export function chat_board_date(date) {
  let currentDate = parseDate(date)
  let fullWeekDayName = currentDate.toLocaleString("default", { weekday: "long" })
  
  return fullWeekDayName + ' ' + roundUpNumber(currentDate.getDate()) + '.' + roundUpNumber(currentDate.getMonth() + 1) + '.' + currentDate.getFullYear()
}

function roundUpNumber(number) {
  return (number.toString().length == 1 ? '0' + number : number)
}

function parseDate(date) {
  let parsedDate = date.split(' ')
  let currentDate = parsedDate[0]
  let currentTime = parsedDate[1]
  let currentOffset = parsedDate[2]
  
  currentDate = currentDate.split('-')
  currentTime = currentTime.split(':')
  
  return new Date( currentDate[0], currentDate[1] - 1, currentDate[2], currentTime[0], currentTime[1], currentTime[2]);
}
