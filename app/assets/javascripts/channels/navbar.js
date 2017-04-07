$(document).ready(function() {

  var $navbarLogged = $("#my-navbar-logged");

  if ( $navbarLogged.length > 0 ) {
    var currentUserId = parseInt($navbarLogged.attr('data-user-id'));
    subscribeToUserNotificationsChannel();
  }

});


function subscribeToUserNotificationsChannel() {
  App['user:notifications'] = App.cable.subscriptions.create({channel: 'UserNotificationsChannel'}, {
    received: function(data) {
      $('#my-navbar-badge').html(data.notifications);
      $('#my-navbar-burger-badge').html(data.notifications);
      $('#my-navbar-burger-menu-badge').html(data.notifications);
    }
  });
};
