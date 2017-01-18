function propositionToggle () {

  $('#proposition-toggle').on('click', function(event) {
    event.preventDefault();
    $('#proposition-details').slideToggle('fast');
    $('#proposition-toggle .toggle-link').toggleClass('hidden');
  });

};

$(document).ready(propositionToggle());
