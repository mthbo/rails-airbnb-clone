$(document).ready(function() {

  var $videoCallBtns = $('#video-call-btn');
  var $dashboardBtn = $('#my-navbar-dashboard-btn');
  setObjectiveBtnTooltip();

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

function setObjectiveBtnTooltip() {
  var $addObjectiveBtn = $('#add-objective-btn');
  if (!isMobile()) {
    $addObjectiveBtn.tooltip({
      trigger: 'hover',
      placement: 'bottom'
    });
  }
}
