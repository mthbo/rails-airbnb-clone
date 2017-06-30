$(document).ready(function(){

  var gaID = $("#ga-id").data("id");
  if (gaID) {

    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

    ga('create', gaID, 'auto');
    ga('send', 'pageview');

    $('#searchbar-input').focusin(function() {
      ga('send', 'event', 'Search', 'focusin', 'Start searching');
    })

    $('#be-advisor-btn').click(function() {
      ga('send', 'event', 'Become advisor', 'click', 'Go to advisor page');
    })

  }

});
