$( document ).on('turbolinks:load', function() {
  
  // Multilevel Dropdown from https://bootsnipp.com/snippets/xr4GW
  $(".btn-group, .dropdown").hover(
    function () {
      $('>.dropdown-menu', this).stop(true, true).fadeIn("fast");
      $(this).addClass('open');
    },
    function () {
      $('>.dropdown-menu', this).stop(true, true).fadeOut("fast");
      $(this).removeClass('open');
  });
})
