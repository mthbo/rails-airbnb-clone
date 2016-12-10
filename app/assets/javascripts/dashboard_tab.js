$(function(){

  $(".tab").on("click", function(e){
    $(".tab").removeClass("active");
    $(this).addClass("active");
    $(".tab-content").addClass("hidden");
    var tabContentId = $(this).data("target");
    $(tabContentId).removeClass("hidden");
  });

});
