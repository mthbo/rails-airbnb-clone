function legalTypeCheck () {

  var $legalTypeButtons = $(".user_legal_type");
  var $businessDetails = $(".user-business-details");

  $legalTypeButtons.on('change', function() {
    if ($("#user_legal_type_company")[0].checked) {
      $businessDetails.removeClass('hidden');
    } else {
      $businessDetails.addClass('hidden');
    }
  });


};


$(document).ready(legalTypeCheck());
