$(function(){

  $(".dashboard-tab").on("click", function(e){
    $(".dashboard-tab").removeClass("active");
    $(this).addClass("active");
    $(".dashboard-tab-content").addClass("hidden");
    var tabContentId = $(this).data("target");
    $(tabContentId).removeClass("hidden");
  });

});
