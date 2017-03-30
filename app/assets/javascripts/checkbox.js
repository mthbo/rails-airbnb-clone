function checkBox () {

  $checkBoxes = $(".custom-check-boxes input")

  $checkBoxes.each(function() {
    checkBoxAppearance(this);
  });

  $checkBoxes.on('change', function() {
    checkBoxAppearance(this);
  });

};


function checkBoxAppearance(checkBox) {
  if (checkBox.checked) {
    $(checkBox).parent().css('background-color', 'white');
    $(checkBox).parent().css('border-color', 'rgb(74,74,74)');
  } else {
    $(checkBox).parent().css('background-color', 'rgba(250,250,250,0.7)');
    $(checkBox).parent().css('border-color', 'rgb(215,215,215)');
  }
}


$(document).ready(checkBox());
