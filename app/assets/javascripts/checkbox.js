$(function(){

  $(".custom-check-boxes input").change(function() {
    if (this.checked) {
      $(this).parent().css('background-color', 'rgb(240,240,240)');
      $(this).parent().css('border-color', 'rgb(157,157,157)');
    } else {
      $(this).parent().css('background-color', 'white');
      $(this).parent().css('border-color', 'rgb(215,215,215)');
    }
  });

});
