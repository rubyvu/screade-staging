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

export function chat_time(timestamp) {
  let currentDate = new Date(timestamp*1000)
  
  if (!isTwelveHoursFormat()) {
    // dd.mm.yyyy
    return new Intl.DateTimeFormat('default', { hour12: false, hour: 'numeric', minute: 'numeric' }).format(currentDate);
  } else {
    // mm/dd/yyy
    // Intl.DateTimeFormat is broken for Chrom browser, return 0:00 instead 12:00, so use custom method formatAMPM()
    // return new Intl.DateTimeFormat('default', { hour12: true, hour: 'numeric', minute: 'numeric' }).format(currentDate).toUpperCase();
    
    function formatAMPM(date) {
      var hours = date.getHours();
      var minutes = date.getMinutes();
      var ampm = hours >= 12 ? 'PM' : 'AM';
      hours = hours % 12;
      hours = hours ? hours : 12; // the hour '0' should be '12'
      minutes = minutes < 10 ? '0'+minutes : minutes;
      var strTime = hours + ':' + minutes + ' ' + ampm;
      return strTime;
    }
    
    return formatAMPM(currentDate)
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
  
  let newDate =  new Date(currentDate[0], currentDate[1] - 1, currentDate[2], currentTime[0], currentTime[1], currentTime[2]);
  newDate = new Date(newDate.getTime())
  return newDate
}
