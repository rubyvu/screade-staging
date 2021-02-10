$( document ).on('turbolinks:load', function() {
  
  // Show modal User password input
  $("#show-password-icon").on('click', function() {
    let input = $(".modal #user_password")
    if (input.attr("type") === "password") {
      $(this).css("opacity", 1)
      input.attr("type", "text");
    } else {
      $(this).css("opacity", 0.4)
      input.attr("type", "password");
    }
  })
  
  // Clear fields/errors on modal hide
  $('.modal').on('hide.bs.modal', function (e) {
    $('.modal :input').not(':button, :submit, :reset, :hidden').val('').prop('checked', false).prop('selected', false);
    $('.modal .global-errors').html('')
  })
  
  // Clear global error on
  $('.modal :input').change(function() {
    $('.modal .global-errors').html('')
  })
})
