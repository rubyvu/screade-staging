$( document ).on('turbolinks:load', function() {
  if ($('#font-customizer').length === 0) { return }
  
  $('#font-customizer').on('click', "input[id*='setting_font_family']", function() {
    let alphabetToChange = $('#alphabet-view')
    let checkedFont = $("input[id*='setting_font_family']:checked")
    
    alphabetToChange.removeClass('roboto vivaldi times-new-roman broadway')
    switch(checkedFont.val()) {
    case 'vivaldi':
      alphabetToChange.addClass('vivaldi')
      break;
    case 'times-new-roman':
      alphabetToChange.addClass('times-new-roman')
      break;
    case 'broadway':
      alphabetToChange.addClass('broadway')
    default:
      alphabetToChange.addClass('roboto')
    }
  });
  
  $('#font-customizer').on('click', "input[id*='setting_font_style']", function() {
    let alphabetToChange = $('#alphabet-view')
    let checkedStyle = $("input[id*='setting_font_style']:checked")
    
    alphabetToChange.removeClass('normal bold italic')
    switch(checkedStyle.val()) {
    case 'bold':
      alphabetToChange.addClass('bold')
      break;
    case 'italic':
      alphabetToChange.addClass('italic')
    default:
      alphabetToChange.addClass('normal')
    }
  });
})
