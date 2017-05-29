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

});
