$(document).ready(function() {

  var $session = $("#session-page");

  if ( $session.length > 0 ) {

    var currentUserId = parseInt($("#my-navbar-logged").attr('data-user-id'));
    var dealId = parseInt($session.attr('data-deal-id'));

    App['deal' + dealId + ':messages'] = App.cable.subscriptions.create({channel: 'MessagesChannel', deal_id: dealId}, {
      received: function(data) {
        if (data.state === "typing" && currentUserId !== data.user_id) {
          $('#message-typing').removeClass("hide");
        } else if (data.state === "stop_typing" && currentUserId !== data.user_id) {
          $('#message-typing').addClass("hide");
        } else if (data.state === "sending") {
          var $new_message = $(data.message).hide();
          if (currentUserId !== data.user_id) {
            $new_message.removeClass("message-right");
            $new_message.removeClass("message-yellow");
            $new_message.removeClass("message-green");
            $new_message.addClass("message-left");
          }
          $('#message-typing').before($new_message);
          $new_message.show();
          scrollConversation();
        }
      },

    });

  }

});
