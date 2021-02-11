import "select2";
import "select2/dist/css/select2.min.css"
import "flag-icon-css/css/flag-icon.css"

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
  
  // County field
  $('#user_country_id').select2({
    dropdownParent: $('.sign-up-modal-lg'),
    templateResult: formatCountry
  });
  
  function formatCountry (country) {
    if (!country.id) { return country.text; }
    var $country = $(
      '<span class="flag-icon flag-icon-'+ country.id.toLowerCase() +' flag-icon-squared"></span>' +
      '<span class="flag-text">'+ country.text+"</span>"
    );
    return $country;
  };
  
  // Secret Question field
  $('#user_user_security_question_id').select2({
    dropdownParent: $('.sign-up-modal-lg')
  })
})
