$(document).ready(function(){

  $copyLinkBtn = $('#copyLinkBtn');
  $copyLinkBtn.attr("data-clipboard-text", window.location.href);

  if (isMobile()) {
    $copyLinkBtn.tooltip({
      trigger: 'click',
      placement: 'auto bottom'
    });
  } else {
    $copyLinkBtn.tooltip({
      trigger: 'hover',
      placement: 'auto bottom'
    });
  }

  // Clipboard

  var clipboard = new Clipboard('#copyLinkBtn');

  clipboard.on('success', function(e) {
    setTooltip(e.trigger, I18n.t('share.link_copied'));
    hideTooltip(e.trigger);
  });

  clipboard.on('error', function(e) {
    setTooltip(e.trigger, I18n.t('share.copy_failed'));
    hideTooltip(e.trigger);
  });

});

function setTooltip(btn, message) {
  $(btn).attr('data-original-title', message).tooltip('show');
}

function hideTooltip(btn) {
  setTimeout(function() {
    $(btn).tooltip('hide').attr('data-original-title', I18n.t('share.copy_link'));
  }, 1500);
}
