$(document).ready(function() {

  var $dashboard = $('#dashboard-page');
  if ( $dashboard.length > 0 ) {

    var $deals = $(".deal-card");
    if ( $deals.length > 0 ) {
      $deals.each(function() {
        var dealId = parseInt($(this).attr('data-deal-id'));
        subscribeToCardsChannel(dealId);
      })
    };

    App['newDeal:cards'] = App.cable.subscriptions.create({channel: 'NewDealCardsChannel'}, {
      received: function(data) {
        $(data.card).hide().prependTo($('#request-sessions')).slideDown();
        subscribeToCardsChannel(data.deal_id);
      },
    });

  };

});


function subscribeToCardsChannel(dealId) {
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
    },

  });
};
