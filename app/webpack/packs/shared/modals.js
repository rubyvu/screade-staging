import moment from 'moment';
import "flag-icon-css/css/flag-icon.css"

$( document ).on('turbolinks:load', function() {
  // Update user birthday date
  $("#birthday_day, #birthday_month, #birthday_year").on('change', function () {
    let year = $('#birthday_year').val()
    let month = $('#birthday_month').val()
    let day = $('#birthday_day').val()
    
    let date = moment(new Date(year, day, month)).format('YYYY-MM-DD')
    $('#sign_up_update_user_birthday').val(date)
  })
  
  // Show modal User password input
  $("#show-password-icon").on('click', function() {
    let input = $(".modal #sign_in_user_password")
    if (input.attr("type") === "password") {
      $(this).css("opacity", 1)
      input.attr("type", "text");
    } else {
      $(this).css("opacity", 0.4)
      input.attr("type", "password");
    }
  })
  
  // Hide all modals on new modal open
  $('.modal').on('show.bs.modal', function () {
    $('.modal').modal('hide')
  })
  
  // Clear fields/errors on modal hide
  $('.modal').on('hide.bs.modal', function (e) {
    $('.modal :input').not(':button, :submit, :reset, :hidden, .datepicker').val('').prop('checked', false).prop('selected', false);
    $('.modal .global-errors').html('')
    $('.modal .local-errors').remove()
  })
  
  // Clear global error on
  $('.modal :input').change(function() {
    $('.modal .global-errors').html('')
  })
  
  // County field
  $('#sign_up_user_country_id').select2({
    dropdownParent: $('#modal-sign-up'),
    templateResult: formatCountry
  });
  
  function formatCountry (country) {
    if (!country.title) { return country.text; }
    var $country = $(
      '<span class="flag-icon flag-icon-'+ country.title.toLowerCase() +' flag-icon-squared"></span>' +
      '<span class="flag-text">'+ country.text+"</span>"
    );
    return $country;
  };
  
  // Secret Question field
  $('#sign_up_user_user_security_question_id').select2({
    dropdownParent: $('#modal-sign-up')
  })
  
  $('#forgot_password_user_user_security_question_id').select2({
    dropdownParent: $('#modal-forgot-password')
  })
  
  // Block submit button on Sign Up
  let signUpSubmitButton = $('#sign-up-submit-button')
  
  $('#modal-sign-up').on('show.bs.modal', function (e) {
    signUpSubmitButton.prop('disabled', true)
  })
  
  $('#term-and-services-agreement').on('change', function() {
    if ($(this).is(":checked")) {
      signUpSubmitButton.prop('disabled', false)
    } else {
      signUpSubmitButton.prop('disabled', true)
    }
  })
  
  // Photo preview
  $('#banner-image-mask').on('click', function() {
     $("#sign_up_update_user_banner_picture").click();
  })
  
  $('#profile-image-mask').on('click', function() {
     $("#sign_up_update_user_profile_picture").click();
  })
  
  $("#sign_up_update_user_banner_picture").change(function() {
    readBannerURL(this);
  });
  
  $("#sign_up_update_user_profile_picture").change(function() {
    readProfileURL(this);
  });
  
  function readBannerURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $('#banner-image').attr('src', e.target.result);
        $('#banner-image').show();
        $('#icon-add-banner').hide();
      }
      
      reader.readAsDataURL(input.files[0]);
    }
  }
  
  function readProfileURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $('#profile-image').attr('src', e.target.result);
        $('#profile-image').show();
        $('#icon-add-profile').hide();
      }
      
      reader.readAsDataURL(input.files[0]);
    }
  }
})
