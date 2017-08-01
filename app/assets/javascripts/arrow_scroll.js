$(function(){

  $('#home-arrow-down').on('click', function(event) {
    event.preventDefault();
    window.scroll({ top: window.innerHeight, left: 0, behavior: 'smooth' });
  });

});
