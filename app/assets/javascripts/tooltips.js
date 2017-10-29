$(document).ready(function() {

  var $videoCallBtns = $('#video-call-btn');
  var $dashboardBtn = $('#my-navbar-dashboard-btn');

  if (!isMobile()) {
    $videoCallBtns.tooltip({
      trigger: 'hover',
      placement: 'bottom'
    });

    $dashboardBtn.tooltip({
      trigger: 'hover',
      placement: 'bottom'
    });
  }
});
