$(document).ready(function() {;
  unactivateLoader();
});

$(document).on('ajaxSend', function(event, xhr, settings){
  if (settings.noLoader) return true;
  showloader()
});

$(document).on('ajaxStop', function(){
  hideloader()
});

function showloader(){
 $(".modal").modal('hide');
 $("#custom-loader").modal('show');
}

function hideloader(){
 $("#custom-loader").modal('hide');
}

function unactivateLoader(){
  $("[data-no-loader=true]").on('ajax:beforeSend', function(event, xhr, settings) {
    settings.noLoader = true;
  });
}

function unactivateLoaderElements($elements){
  $elements.on('ajax:beforeSend', function(event, xhr, settings) {
    settings.noLoader = true;
  });
}
