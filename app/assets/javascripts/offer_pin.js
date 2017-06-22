$(document).ready(function() {

  $('.pin-unpin-offer').tooltip({
    trigger: 'hover',
    placement: 'bottom'
  });

  var $pin_button = $('.pin-unpin-offer');
  $pin_button.click(function() {
    $(this).animate({top:"-=15px"}, 200, function() {
      $(this).animate({top:"+=15px"}, 100, 'swing', function() {
        if ($(this).hasClass('unpin-offer-button')) {
          $(this).addClass('pin-offer-button');
          $(this).removeClass('unpin-offer-button');
          $(this).attr('data-original-title', "Epingler l'offre");
        } else if ($(this).hasClass('pin-offer-button')) {
          $(this).addClass('unpin-offer-button');
          $(this).removeClass('pin-offer-button');
          $(this).attr('data-original-title', "Oublier l'offre");
        }
      });
    });
  })

});
