export function chat_date(date){
  console.log(date);
  let parsedDate = date.split(' ')
  let currentDate = parsedDate[0]
  let currentTime = parsedDate[1]
  let currentOffset = parsedDate[2]
  
  currentDate = currentDate.split('-')
  currentTime = currentTime.split(':')
  
  // year monthIndex day
  //let newDate = new Date( currentDate[2], currentDate[0] - 1, currentDate[1], currentTime[0], currentTime[1], currentTime[2]);
  
  if (!isTwelveHoursFormat()) {
    // dd.mm.yyyy
    return currentDate[2] + '.' + currentDate[1] + '.' + currentDate[0]
  } else {
    // mm/dd/yyy
    return currentDate[1] + '/' + currentDate[2] + '/' + currentDate[0]
  }
}
