$(window).on("load", function() {
  scrollConversation();
});

function scrollConversation () {
  var $panel = $("#deal-conversation-panel");
  if ($panel.length > 0) {
    $panel.scrollTop($panel[0].scrollHeight);
  }
};

