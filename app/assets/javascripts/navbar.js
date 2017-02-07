if (($('.my-navbar').length > 0) && ($('.home').length > 0)) {
  $(window).on("scroll load resize", function(){
    checkScroll();
  });
}

function checkScroll(){
  var startY = $('.my-navbar').height() * 2;

  if($(window).scrollTop() < startY && $('.mobile-dropdown-menu').is(":hidden")) {
    $('.my-navbar').addClass("my-navbar-scrolled");
  } else {
    $('.my-navbar').removeClass("my-navbar-scrolled");
  }
};
