$(document).ready(function() {

  var $dashboard = $('#dashboard-page');
  if ( $dashboard.length > 0 ) {

    var $deals = $(".deal-card");
    $deals.each(function() {
      var dealId = parseInt($(this).attr('data-deal-id'));
      subscribeToDealCardsChannel(dealId);
      subscribeToMessageNotificationsChannel(dealId);
    })

    App['newDeal:cards'] = App.cable.subscriptions.create({channel: 'NewDealCardsChannel'}, {
      received: function(data) {
        $(data.card).hide().prependTo($('#request-deals')).slideDown();
        subscribeToDealCardsChannel(data.deal_id);
        subscribeToMessageNotificationsChannel(data.deal_id);
        updateDealsCurrentNotifications();
        updateDealsPastNotifications();
        updateDealsCancelledNotifications();
      },
    });

  };

});


function subscribeToDealCardsChannel(dealId) {
  App['deal' + dealId + ':cards'] = App.cable.subscriptions.create({channel: 'DealCardsChannel', deal_id: dealId}, {
    received: function(data) {
      $('[data-deal-id=' + dealId + ']').slideUp().remove();
      switch (data.status) {
        case 'request':
          $(data.card).hide().prependTo($('#request-deals')).slideDown();
          break;
        case 'proposition':
          $(data.card).hide().prependTo($('#proposition-deals')).slideDown();
          break;
        case 'open':
          $(data.card).hide().prependTo($('#open-deals')).slideDown();
          break;
        case 'closed_recent':
          $(data.card).hide().prependTo($('#closed-deals-recent')).slideDown();
          break;
        case 'closed_old':
          $(data.card).hide().prependTo($('#closed-deals-old')).slideDown();
          break;
        case 'cancelled':
          $(data.card).hide().prependTo($('#cancelled-deals-all')).slideDown();
        deals
      }
      updateDealsCurrentNotifications();
      updateDealsPastNotifications();
      updateDealsCancelledNotifications();
    }

  });
};

function subscribeToMessageNotificationsChannel(dealId) {
  App['deal' + dealId + ':notifications'] = App.cable.subscriptions.create({channel: 'DealNotificationsChannel', deal_id: dealId}, {
    received: function(data) {
      $('[data-deal-id=' + dealId + '] .deal-card-notifications').html(data.notifications);
      updateDealsCurrentNotifications();
      updateDealsPastNotifications();
      updateDealsCancelledNotifications();
    }

  });
};


function updateDealsCurrentNotifications() {
  var $dealsCurrentNotifications = $('#current-deals .badge-notification');
  var notificationsCount = 0;
  $dealsCurrentNotifications.each(function() {
    notificationsCount += parseInt($(this).text());
  });
  if (notificationsCount === 0) {
    $('#deals-current-notifications').addClass('hidden');
  } else {
    $('#deals-current-notifications').text(notificationsCount).removeClass('hidden');
  }
};

function updateDealsPastNotifications() {
  var $dealsPastNotifications = $('#past-deals .badge-notification');
  var notificationsCount = 0;
  $dealsPastNotifications.each(function() {
    notificationsCount += parseInt($(this).text());
  });
  if (notificationsCount === 0) {
    $('#deals-past-notifications').addClass('hidden');
  } else {
    $('#deals-past-notifications').text(notificationsCount).removeClass('hidden');
  }
};

function updateDealsCancelledNotifications() {
  var $dealsCancelledNotifications = $('#cancelled-deals .badge-notification');
  var notificationsCount = 0;
  $dealsCancelledNotifications.each(function() {
    notificationsCount += parseInt($(this).text());
  });
  if (notificationsCount === 0) {
    $('#deals-cancelled-notifications').addClass('hidden');
  } else {
    $('#deals-cancelled-notifications').text(notificationsCount).removeClass('hidden');
  }
};
