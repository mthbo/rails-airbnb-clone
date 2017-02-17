function propositionToggle () {

  $('#deal-proposition-toggle').on('click', function(event) {
    event.preventDefault();
    $('#deal-proposition-details').slideToggle('fast');
    $('#deal-proposition-toggle .toggle-link').toggleClass('hidden');
  });

};

$(document).ready(propositionToggle());
