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
      if (!$('#searchbar').hasClass('hidden')) {
        $('#searchbar').addClass('hidden');
        $('#searchbar-input').focusout();
      }
    });

    $('#searchbar-input').on('input focusin', function() {
      if ($(this).val() === "") {
        $('#search-page-wrapper').addClass('hidden');
        $('#main').removeClass('hidden');
      } else {
        $('#search-page-wrapper').removeClass('hidden');
        $('#main').addClass('hidden');
        filtersDiscloseContent();
      }
    });

    $('#search-filters-toggle').on('click', function(event) {
      event.preventDefault();
      $('#search-filters').slideToggle('fast');
      $('#search-filters-toggle .toggle-link').toggleClass('hidden');
    });

    $('#search-filters-clear').on('click', function(event) {
      event.preventDefault();
      $('#searchbar-input').val("");
      $('#search-page-wrapper').addClass('hidden');
      $('#main').removeClass('hidden');
    });

  }

});

function filtersDiscloseContent() {
  if ($('.ais-hits__empty').length === 0) {
    $('#search-filters-toggle').removeClass('hidden');
    $('#search-filters-clear').addClass('hidden');
  } else {
    $('#search-filters-toggle').addClass('hidden');
    $('#search-filters-clear').removeClass('hidden');
  }
}

  // $('.search-clear').on(click, function() {
  //   console.log("coucou");
  //   $('#searchbar-input').val("");
  // });
