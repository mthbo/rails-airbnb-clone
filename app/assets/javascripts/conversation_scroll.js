function scrollConversation () {

  var $panel = $("#session-conversation-panel");
  if ($panel.length > 0) {
    $panel.scrollTop($panel[0].scrollHeight);
  }

};

$(document).on('turbolinks:load', function() {
  scrollConversation();
});
