$( document ).on('turbolinks:load', function() {
  // News Switcher from National to World
  $('#news-switcher').click(function() {
    var queryParams = new URLSearchParams(window.location.search);
    if( $(this).is(':checked') ) {
      queryParams.set("is_national", "false");
    } else {
      queryParams.set("is_national", "true");
    }
    
    queryParams.set("page", "1");
    history.replaceState(null, null, "?"+queryParams.toString());
    window.location.href = document.URL
  });
  
  // News Articles Lits for on Home and NewsArticles Comments pages
  $('.ic.lit').parent().on('click', function() {
    const iconObject = $(this)
    
    // Do not send request if icon disabled
    if ( $(this).hasClass('pointer-disable') ) { return }
    
    var articleId = ''
    // Get Article ID from Home or NewsArticles Comments pages
    if ($('.news-card').length > 0) {
      articleId = iconObject.parents('.news-card:first').attr('value');
    } else if ( $('.news-info-panel').length > 0 ) {
      articleId = iconObject.parents('.news-info-panel:first').attr('value');
    }
    
    var litCounter = +(iconObject.children('span').text())
    
    if ( iconObject.children('.ic').hasClass('active') ) {
      $.ajax({
        type: "DELETE",
        url: window.location.origin + '/news_articles/' + articleId + '/unlit'
      }).done(function( data ) {
        if ( data.success ) {
          iconObject.children('.ic').removeClass('active')
          iconObject.children('span').text(litCounter-1)
         }
      });
    } else {
      $.ajax({
        type: "POST",
        url: window.location.origin + '/news_articles/' + articleId + '/lit'
      }).done(function( data ) {
        if ( data.success ) {
          iconObject.children('.ic').addClass('active')
          iconObject.children('span').text(litCounter+1)
        }
      });
    }
  })
  
  // News Articles Views
  $('.news-article-link').on('click', function() {
    const iconObject = $(this).closest('.news-card').find('i.ic.view')
    const articleId = iconObject.parents('.news-card:first').attr('value');
    var viewCounter = +(iconObject.children('span').text())
    
    if ( !iconObject.children('.ic').hasClass('active') ) {
      $.ajax({
        type: "POST",
        url: window.location.origin + '/news_articles/' + articleId + '/view'
      }).done(function( data ) {
        if ( data.success ) {
          iconObject.addClass('active')
          iconObject.parent().children('span').text(viewCounter+1)
        }
      });
    }
  })
});
