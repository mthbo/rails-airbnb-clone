$(document).ready(function(){

  setTimeout(function(){
    $('.alert').fadeOut('slow', function() {
      $(this).remove();
    });
  }, 2500);

});
