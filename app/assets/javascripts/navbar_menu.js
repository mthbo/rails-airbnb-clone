$(document).ready(function() {

  if ($('.my-navbar').length > 0) {
    $('#my-navbar-locale-toggle').on('click', function(event) {
      event.stopPropagation();
      hideProfileMenuIfVisible();
      if ($('#my-navbar-locale-menu').is(':hidden')) {
        showLocaleMenu();
      } else {
        hideLocaleMenu();
      }
    });

    $('#my-navbar-profile-toggle').on('click', function(event) {
      event.stopPropagation();
      hideLocaleMenuIfVisible();
      $('#my-navbar-profile-menu').slideToggle(150);
    });

    $(window).on('click', function() {
      hideLocaleMenuIfVisible();
      hideProfileMenuIfVisible();
    });
  }

});

function showLocaleMenu() {
  $('#my-navbar-locale-menu').slideDown(150);
  $('#my-navbar-locale-toggle i').remove();
  $('#my-navbar-locale-toggle').append("<i class='fa fa-caret-up' aria-hidden='true'></i>")
}

function hideLocaleMenu() {
  $('#my-navbar-locale-menu').slideUp(150);
  $('#my-navbar-locale-toggle i').remove();
  $('#my-navbar-locale-toggle').append("<i class='fa fa-caret-down' aria-hidden='true'></i>")
}

function hideLocaleMenuIfVisible() {
  if ($('#my-navbar-locale-menu').is(':visible')) {
    $('#my-navbar-locale-menu').slideUp(150);
    $('#my-navbar-locale-toggle i').remove();
    $('#my-navbar-locale-toggle').append("<i class='fa fa-caret-down' aria-hidden='true'></i>")
  }
}

function hideProfileMenuIfVisible() {
  if ($('#my-navbar-profile-menu').is(':visible')) {
    $('#my-navbar-profile-menu').slideUp(150);
  }
}
