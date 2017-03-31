$(document).ready(function(){

  if ($('.home').length > 0) {
    if (isMobile()) {
      $('#home-inspirations-moving').addClass('hidden');
      $('#home-inspirations-fixed').removeClass('hidden');
    }
  }

});
