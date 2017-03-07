$(function(){

  $('#home-arrow-down').on('click', function(event) {
    event.preventDefault();
    window.scroll({ top: $('#home-banner').height(), left: 0, behavior: 'smooth' });
  });

});
