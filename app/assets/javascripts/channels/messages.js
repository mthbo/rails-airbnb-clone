$(document).ready(function() {

  var $messages = $("#session-conversation-messages");

  if ( $messages.length > 0 ) {

    var currentUserId = parseInt($("#my-navbar-logged").attr('data-user-id'));
    var dealId = parseInt($messages.attr('data-deal-messages-id'));

    App['deal' + dealId] = App.cable.subscriptions.create({channel: 'MessagesChannel', deal_id: dealId}, {
      received: function(data) {
        $("[data-deal-messages-id='" + dealId + "']").append(this.renderMessage(data, currentUserId));
        scrollConversation ();
        $("[data-user-form-id='" + data.user_id + "'] #message_content").val("");
      },

      renderMessage: function(data, currentUserId) {
        if (currentUserId !== data.user_id) {
          return "<div class='message-box message-left'><div class='message'><p>" + data.content + "</p></div></div>";
        } else {
          return "<div class='message-box message-right'><div class='message'><p>" + data.content + "</p></div></div>";
        }
      }

    });

  }

});
