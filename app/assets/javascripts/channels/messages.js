$(document).ready(function() {

  var $messages = $("#session-conversation-messages");

  if ( $messages.length > 0 ) {

    var currentUserId = parseInt($("#my-navbar-logged").attr('data-user-id'));
    var dealId = parseInt($messages.attr('data-deal-messages-id'));

    App['deal' + dealId] = App.cable.subscriptions.create({channel: 'MessagesChannel', deal_id: dealId}, {
      received: function(data) {
        if (data.state === "typing" && currentUserId !== data.user_id) {
          $('#message-typing').removeClass("hide");
          scrollConversation ();
        } else if (data.state === "stop_typing" && currentUserId !== data.user_id) {
          $('#message-typing').addClass("hide");
        } else if (data.state === "sending") {
          var $new_message = $(data.message).hide();
          if (currentUserId !== data.user_id) {
            $new_message.removeClass("message-right");
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
