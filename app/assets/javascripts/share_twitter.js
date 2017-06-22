$(document).ready(function() {

  var $liBtn = $('#twitterShareBtn');
  var x = screen.width/2 - 570/2;
  var y = screen.height/2 - 250/2;

  if (!isMobile()) {
    $liBtn.tooltip({
      trigger: 'hover',
      placement: 'auto bottom'
    });
  }

  $liBtn.click(function() {
    window.open("https://twitter.com/share?"
        + "text=" + I18n.t('share.have_a_look')
        + "&hashtags=" + I18n.t('share.advice') + "," + I18n.t('share.services') + "," + I18n.t('share.collaborative') + "," + I18n.t('share.market') + "," + I18n.t('share.knowledge')
        + "&via=papotersapp"
        + "&url=" + window.location.href,
      "Twitter",
      'width=570,height=250,left=' + x + ',top=' + y
    );
  })

});
