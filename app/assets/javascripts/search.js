$(document).ready(function() {

  if ($('.my-navbar').length > 0) {

    $('#btn-search-trigger').on('click', function() {
      $('#searchbar').toggleClass('hidden');
      $('#searchbar-input').focus();
      if
      $('#search-page-wrapper').addClass('hidden');
      $('#main').removeClass('hidden');
    });

    $('#searchbar-input').on('input', function() {
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
