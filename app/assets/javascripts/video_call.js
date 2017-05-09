$(document).ready(function() {

  // get a guaranteed unique and random room name inside appear.in

  var $roomNameField = $("#deal_room_name");

  if ($roomNameField.length > 0) {
    var AppearIn = window.AppearIn;
    var appearin = new AppearIn();

    if ($roomNameField.val() === "") {
      appearin.getRandomRoomName().then(function (roomName) {
        $roomNameField.val(roomName);
      });
    }
  }

  // add the room to an iframe DOM Element

  var $videoCall = $("#video-call");

  if ($videoCall.length > 0) {
    var AppearIn = window.AppearIn;
    var appearin = new AppearIn();

    var roomName = $videoCall.attr('data-room-name');
    $("#video-call-modal").on('shown.bs.modal', function () {
      appearin.addRoomToElementById("video-call-frame", roomName);
    });
  }

});
