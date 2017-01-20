$(document).ready(function() {

  var $session = $("#session-page");

  if ( $session.length > 0 ) {

    var currentUserId = parseInt($("#my-navbar-logged").attr('data-user-id'));
    var dealId = parseInt($session.attr('data-deal-id'));

    App['deal' + dealId + ':status'] = App.cable.subscriptions.create({channel: 'DealStatusChannel', deal_id: dealId}, {
      received: function(data) {
        $('#session-status-panel').html(data.status);
        $('#session-info-panel').html(data.info);
        $('#session-actions-panel').html(data.actions);
        console.log(data.messages_disabled);
        if (data.messages_disabled === true) {
          $('#message_content').prop('disabled', true);
          $('#new_message button').prop('disabled', true);
        }
        propositionToggle();
      },

    });

  }

});

