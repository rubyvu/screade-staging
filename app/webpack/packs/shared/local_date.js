$(document).on('turbolinks:load', function () {
  var current_time = new Date();
  document.cookie = `time_zone= ${current_time.getTimezoneOffset()}`;
})
