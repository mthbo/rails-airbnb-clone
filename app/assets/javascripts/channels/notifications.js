$(document).ready(function() {

  var $deals = $(".deal-card");

  if ( $deals.length > 0 ) {

    $deals.each(function() {
      var dealId = parseInt($(this).attr('data-deal-id'));
      var $counter = $('[data-deal-id=' + dealId + '] .badge-notification');

      App['deal' + dealId + ':notifications'] = App.cable.subscriptions.create({channel: 'DealNotificationsChannel', deal_id: dealId}, {
        received: function(data) {
          var val = parseInt($counter.text());
          val++;
          $counter.text(val);
          $counter.show();
        },

      });
    })
  }

});
