$(document).ready(function() {

  var $dashboard = $('#dashboard-page');
  if ( $dashboard.length > 0 ) {

    var $deals = $(".deal-card");
    if ( $deals.length > 0 ) {
      $deals.each(function() {
        var dealId = parseInt($(this).attr('data-deal-id'));
        subscribeToDealCardsChannel(dealId);
        subscribeToMessageNotificationsChannel(dealId);
      })
    };

    App['newDeal:cards'] = App.cable.subscriptions.create({channel: 'NewDealCardsChannel'}, {
      received: function(data) {
        $(data.card).hide().prependTo($('#request-sessions')).slideDown();
        subscribeToDealCardsChannel(data.deal_id);
        subscribeToMessageNotificationsChannel(data.deal_id);
      },
    });

  };

});


function subscribeToDealCardsChannel(dealId) {
  App['deal' + dealId + ':cards'] = App.cable.subscriptions.create({channel: 'DealCardsChannel', deal_id: dealId}, {
    received: function(data) {
      $('[data-deal-id=' + dealId + ']').slideUp();
      switch (data.status) {
        case 'request':
          $(data.card).hide().prependTo($('#request-sessions')).slideDown();
          break;
        case 'proposition':
          $(data.card).hide().prependTo($('#proposition-sessions')).slideDown();
          break;
        case 'open':
          $(data.card).hide().prependTo($('#open-sessions')).slideDown();
          break;
        case 'closed_recent':
          $(data.card).hide().prependTo($('#closed-sessions-recent')).slideDown();
          break;
        case 'closed_old':
          $(data.card).hide().prependTo($('#closed-sessions-old')).slideDown();
          break;
        case 'cancelled':
          $(data.card).hide().prependTo($('#cancelled-sessions-all')).slideDown();
          break;
      }
    }

  });
};

function subscribeToMessageNotificationsChannel(dealId) {
  App['deal' + dealId + ':notifications'] = App.cable.subscriptions.create({channel: 'MessageNotificationsChannel', deal_id: dealId}, {
    received: function(data) {
      console.log(data.notifications);
      $('[data-deal-id=' + dealId + '] .deal-card-notifications').html(data.notifications);
    }

  });
};
