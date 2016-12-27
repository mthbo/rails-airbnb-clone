$(function(){

  $checkBoxes = $(".custom-check-boxes input")

  $checkBoxes.each(function() {
    checkBoxAppearance(this);
  });

  $checkBoxes.on('change', function() {
    checkBoxAppearance(this);
  });
});


function checkBoxAppearance(checkBox) {
  if (checkBox.checked) {
    $(checkBox).parent().css('background-color', 'rgb(240,240,240)');
    $(checkBox).parent().css('border-color', 'rgb(157,157,157)');
  } else {
    $(checkBox).parent().css('background-color', 'white');
    $(checkBox).parent().css('border-color', 'rgb(215,215,215)');
  }
}
