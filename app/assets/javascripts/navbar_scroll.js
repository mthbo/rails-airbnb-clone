function checkScroll(){
  var startY = $('.my-navbar').height() * 2;

  if($(window).scrollTop() < startY) {
    $('.my-navbar').addClass("my-navbar-scrolled");
    $('#my-navbar-search').hide();
  } else {
    $('.my-navbar').removeClass("my-navbar-scrolled");
    $('#my-navbar-search').show();
  }
};
