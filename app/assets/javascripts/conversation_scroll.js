function scrollConversation () {

  $(".session-conversation-panel").scrollTop($(".session-conversation-panel")[0].scrollHeight);

};


$(document).ready(scrollConversation());
