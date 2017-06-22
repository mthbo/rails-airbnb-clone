$(document).ready(function() {

  var $liBtn = $('#linkedInShareBtn');
  var x = screen.width/2 - 570/2;
  var y = screen.height/2 - 520/2;

  if (!isMobile()) {
    $liBtn.tooltip({
      trigger: 'hover',
      placement: 'auto bottom'
    });
  }

  $liBtn.click(function() {
    window.open("https://www.linkedin.com/shareArticle?mini=true&url=" + window.location.href,
      "LinkedIn",
      'width=570,height=520,left=' + x + ',top=' + y
    );
  })

});
