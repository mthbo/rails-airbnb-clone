$(document).ready(function() {
  var $pinButtons = $('.pin-unpin-offer');
  buttonsAnimation($pinButtons);
});

function buttonsAnimation(buttons) {
  if (!isMobile()) {
    buttons.tooltip({
      trigger: 'hover',
      placement: 'bottom'
    });
  }

  buttons.click(function() {
    var offerId = $(this).data("offer-id").toLocaleString();
    var currentUserPinnedOffersIds = document.getElementById('current-user').dataset.pinnedOffersIds.toLocaleString().split(" ");
    animateButton($(this), offerId, currentUserPinnedOffersIds);
  });
}

function animateButton(button, offerId, currentUserPinnedOffersIds) {
  button.animate({top:"-=15px"}, 200, function() {
    button.animate({top:"+=15px"}, 100, 'swing', function() {
      if (button.hasClass('unpin-offer-button')) {
        button.addClass('pin-offer-button');
        button.removeClass('unpin-offer-button');
        button.attr('data-original-title', I18n.t('offers.pin_button.pin_offer'));
        var unpinOfferIdIndex = currentUserPinnedOffersIds.indexOf(offerId);
        if (unpinOfferIdIndex >= 0 ) {
          currentUserPinnedOffersIds.splice(unpinOfferIdIndex, 1);
        }
        var currentUserPinnedOffersIdsNew = currentUserPinnedOffersIds.join(" ");
      } else if (button.hasClass('pin-offer-button')) {
        button.addClass('unpin-offer-button');
        button.removeClass('pin-offer-button');
        button.attr('data-original-title', I18n.t('offers.pin_button.forget_offer'));
        var currentUserPinnedOffersIdsNew = currentUserPinnedOffersIds.concat(offerId).join(" ");
      }
      document.getElementById('current-user').setAttribute("data-pinned-offers-ids", currentUserPinnedOffersIdsNew);
    });
  });
}


