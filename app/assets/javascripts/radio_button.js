function radioButton () {

  $radioButtons = $(".custom-radio-buttons > .radio_buttons > .radio > label > input")

  $radioButtons.each(function() {
    radioButtonAppearance(this);
  });

  $radioButtons.on('change', function() {
    $radioButtons.each(function() {
      radioButtonAppearance(this);
    });
  });

};


function radioButtonAppearance(radioButton) {
  if (radioButton.checked) {
    $(radioButton).parent().addClass('label-checked');
  } else {
    $(radioButton).parent().removeClass('label-checked');
  }
}


$(document).ready(radioButton());
