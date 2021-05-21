import consumer from "./consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    let notificationBage = $('#notification-bage')
    
    if ( notificationBage.length === 0 || data.bage_counter === 0 ) { return }
    if (!notificationBage.hasClass('active')) {
      notificationBage.addClass('active')
    }
    
    blinkAnimation(notificationBage)
    
    function blinkAnimation(bage) {
      let i;
      for (i = 0; i < 3; i++) {
        bage.fadeOut(200).fadeIn(300)
      }
    }
  }
});
