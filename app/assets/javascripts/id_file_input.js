$(document).ready(function(){
  $('#user_identity_document').change(function(e){
    var size = e.target.files[0].size;
    if (size < 8000000) {
      var fileName = e.target.files[0].name;
      $('#identity-document-name').html(fileName);
      $("#user_identity_document_name").val(fileName);
    } else {
      $('#identity-document-name').html("<span class='red'>" + I18n.t("users.details.over_size_limit") + "</span>");
    }
  });
});
