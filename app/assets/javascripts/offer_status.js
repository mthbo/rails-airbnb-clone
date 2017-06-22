$(document).ready(function() {

  var $trigger_buttons = $('.offer-trigger-btn');
  var offerId = null;
  var $statusInfo = null;

  if (!isMobile()) {
    $trigger_buttons.tooltip({
      trigger: 'hover',
      placement: 'bottom',
    });
  }

  $trigger_buttons.click(function() {

    offerId = $(this).attr('data-offer-id');
    $statusInfo = $('[data-offer-info-id=' + offerId + ']');

    if ($(this).hasClass('activate-offer-btn')) {
      $(this).animate({left:"+=18px"}, 'fast', 'swing', function() {
        $(this).addClass('inactivate-offer-btn');
        $(this).removeClass('activate-offer-btn');
        $(this).parent().addClass('inactivate-offer-slider');
        $(this).parent().removeClass('activate-offer-slider');
        $(this).attr('data-original-title', I18n.t('offers.status_trigger.inactivate_offer'));
        $statusInfo.addClass('green');
        $statusInfo.removeClass('medium-gray');
        $statusInfo.hide();
        $statusInfo.text(I18n.t('offers.status_info.offer_active_advisor'));
        $statusInfo.fadeIn();
      });
    } else if ($(this).hasClass('inactivate-offer-btn')) {
      $(this).animate({left:"-=18px"}, 'fast', 'swing', function() {
        $(this).addClass('activate-offer-btn');
        $(this).removeClass('inactivate-offer-btn');
        $(this).parent().addClass('activate-offer-slider');
        $(this).parent().removeClass('inactivate-offer-slider');
        $(this).attr('data-original-title', I18n.t('offers.status_trigger.activate_offer'));
        $statusInfo.addClass('medium-gray');
        $statusInfo.removeClass('green');
        $statusInfo.hide();
        $statusInfo.text(I18n.t('offers.status_info.offer_inactive_advisor'));
        $statusInfo.fadeIn();
      });
    }

  })

});
