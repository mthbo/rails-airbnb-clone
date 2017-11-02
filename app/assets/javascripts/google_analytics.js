$(document).ready(function(){

  var gaID = $("#ga-id").data("id");

  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', gaID, 'auto');
  ga('send', 'pageview');

  // Check for GA event trackers for Search in search.js.erb

  // GA event trackers for Welcome page actions

  $('#welcome-user-profile').click(function() {
    ga('send', 'event', 'Welcome', 'click', 'Go to user profile from welcome');
  })
  $('#welcome-search').click(function() {
    ga('send', 'event', 'Welcome', 'click', 'Go to search page from welcome');
  })
  $('#welcome-advisor').click(function() {
    ga('send', 'event', 'Welcome', 'click', 'Go to advisor page from welcome');
  })

  // GA event trackers for Become advisor

  $('#home-be-advisor-btn').click(function() {
    ga('send', 'event', 'Become advisor', 'click', 'Go to advisor page from home page');
  })
  $('#navbar-be-advisor-btn').click(function() {
    ga('send', 'event', 'Become advisor', 'click', 'Go to advisor page from navbar');
  })
  $('#footer-be-advisor-btn').click(function() {
    ga('send', 'event', 'Become advisor', 'click', 'Go to advisor page from footer');
  })

  // GA event trackers for Join groups

  $('#group-join-travelers').click(function() {
    ga('send', 'event', 'Join group', 'click', 'Join Les experts #voyageurs');
  })
  $('#group-join-entrepreneurs').click(function() {
    ga('send', 'event', 'Join group', 'click', 'Join Les experts #entrepreneurs');
  })
  $('#group-join-diy').click(function() {
    ga('send', 'event', 'Join group', 'click', 'Join Les experts #bricoleurs');
  })


  // GA event trackers for Sign up

  $('#sign-up-navbar').click(function() {
    ga('send', 'event', 'Sign up', 'click', 'Sign up from navbar');
  })
  $('#sign-up-advisor-banner').click(function() {
    ga('send', 'event', 'Sign up', 'click', 'Sign up from advisor page banner');
  })
  $('#sign-up-advisor-btn').click(function() {
    ga('send', 'event', 'Sign up', 'click', 'Sign up from advisor page button');
  })
  $('#sign-up-registration-btn').click(function() {
    ga('send', 'event', 'Sign up', 'click', 'Sign up from registration link');
  })

  // GA event trackers for New offer

  $('#publish-offer-advisor-banner').click(function() {
    ga('send', 'event', 'New offer', 'click', 'Publish offer from advisor page banner');
  })
  $('#publish-offer-advisor-btn').click(function() {
    ga('send', 'event', 'New offer', 'click', 'Publish offer from advisor page banner');
  })
  $('#publish-offer-user-profile').click(function() {
    ga('send', 'event', 'New offer', 'click', 'Publish offer from user page');
  })

  // GA event trackers for Session request

  $('#deal-request-btn').click(function() {
    ga('send', 'event', 'Session request', 'click', 'Request for a new session');
  })

});
