$(document).ready(function() {

  var $navbarLogged = $("#my-navbar-logged");

  if ( $navbarLogged.length > 0 ) {
    var currentUserId = parseInt($navbarLogged.attr('data-user-id'));
    var title = document.title;
    updateTitleNotifications(title);
    subscribeToUserNotificationsChannel(title);
  }

});


function subscribeToUserNotificationsChannel(title) {
  App['user:notifications'] = App.cable.subscriptions.create({channel: 'UserNotificationsChannel'}, {
    received: function(data) {
      $('#my-navbar-badge').html(data.notifications);
      $('#my-navbar-burger-badge').html(data.notifications);
      $('#my-navbar-burger-menu-badge').html(data.notifications);
      updateTitleNotifications(title);
    }
  });
};

function updateTitleNotifications(title) {
  var notificationCount = parseInt($('#user-notifications').text());
  if (notificationCount !== 0) {
    var newTitle = '(' + notificationCount + ') ' + title;
    document.title = newTitle;
  } else {
    document.title = title;
  }
}
