$(document).ready(function() {

  if ($('.my-navbar').length > 0) {

    $('#btn-search-trigger').on('click', function() {
      $('#searchbar').toggleClass('hidden');
      if ($('#searchbar').hasClass('hidden')) {
        $('#searchbar-input').focusout();
        $('#search-page-wrapper').addClass('hidden');
        $('#main').removeClass('hidden');
      } else {
        $('#searchbar-input').focus();
      }
    });

    $('#main').on('click', function() {
      $('#searchbar').addClass('hidden');
      $('#searchbar-input').focusout();
    });

    $('#searchbar-input').on('input focusin', function() {
      if ($(this).val() === "") {
        $('#search-page-wrapper').addClass('hidden');
        $('#main').removeClass('hidden');
      } else {
        $('#search-page-wrapper').removeClass('hidden');
        $('#main').addClass('hidden');
      }
    });

  }


});
