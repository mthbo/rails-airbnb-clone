$(document).ready(function() {
  legalTypeCheck();
  var $legalTypeButtons = $(".user_legal_type");
  $legalTypeButtons.on('change', function() {
    legalTypeCheck();
  });
});


function legalTypeCheck() {
  var $businessDetails = $(".user-business-details");
  var $legalTypeCompanyButton = $("#user_legal_type_company")
  if ($legalTypeCompanyButton.length > 0) {
    if ($("#user_legal_type_company")[0].checked) {
      $businessDetails.removeClass('hidden');
    } else {
      $businessDetails.addClass('hidden');
    }
  }
};
