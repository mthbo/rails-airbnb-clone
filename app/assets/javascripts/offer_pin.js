$(document).ready(function() {

  var $pinButtons = $('.pin-unpin-offer');

  if (!isMobile()) {
    $pinButtons.tooltip({
      trigger: 'hover',
      placement: 'bottom'
    });
  }

  $pinButtons.click(function() {
    $(this).animate({top:"-=15px"}, 200, function() {
      $(this).animate({top:"+=15px"}, 100, 'swing', function() {
        if ($(this).hasClass('unpin-offer-button')) {
          $(this).addClass('pin-offer-button');
          $(this).removeClass('unpin-offer-button');
          $(this).attr('data-original-title', I18n.t('offers.pin_button.pin_offer'));
        } else if ($(this).hasClass('pin-offer-button')) {
          $(this).addClass('unpin-offer-button');
          $(this).removeClass('pin-offer-button');
          $(this).attr('data-original-title', I18n.t('offers.pin_button.forget_offer'));
        }
      });
    });
  })

});
