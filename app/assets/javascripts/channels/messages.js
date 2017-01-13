$(document).ready(function() {

  var $messages = $("#session-conversation-messages");

  if ( $messages.length > 0 ) {

    var currentUserId = parseInt($("#my-navbar-logged").attr('data-user-id'));
    var dealId = parseInt($messages.attr('data-deal-messages-id'));

    App['deal' + dealId] = App.cable.subscriptions.create({channel: 'MessagesChannel', deal_id: dealId}, {
      received: function(data) {
        if (data.state === "typing" && currentUserId !== data.user_id) {
          $messages.append(this.renderMessageTyping());
        } else if (data.state === "stop_typing" && currentUserId !== data.user_id) {
          $('#message-typing').remove();
        } else if (data.state === "sending" && $('#message-typing').length > 0) {
          $('#message-typing').remove();
          $messages.append(this.renderMessage(data, currentUserId));
          $messages.append(this.renderMessageTyping());
        } else if (data.state === "sending" && $('#message-typing').length === 0) {
          $messages.append(this.renderMessage(data, currentUserId));
        }

        scrollConversation ();
      },

      renderMessageTyping: function() {
        return "<div class='message-box message-left' id='message-typing'><div class='message'><div class='message-content'><p>• • •</p></div></div></div>";
      },

      renderMessage: function(data, currentUserId) {
        if (currentUserId !== data.user_id) {
          var messageSide = "message-left";
        } else {
          var messageSide = "message-right";
        }
        return "<div class='message-box "
          + messageSide
          + "'><div class='message'><div class='message-content'><p>"
          + data.content
          + "</p></div><div class='message-date'><p><small>"
          + data.date
          + "</small></p></div></div></div>"
        ;
      }

    });

  }

});
