$(document).ready(function() {

  var $videoCallBtns = $('#video-call-btn');

  if (!isMobile()) {
    $videoCallBtns.tooltip({
      trigger: 'hover',
      placement: 'bottom'
    });
  }
});
