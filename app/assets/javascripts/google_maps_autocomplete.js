$(document).ready(function() {
  var user_address = $('#user_address').get(0);

  if (user_address) {
    var autocomplete = new google.maps.places.Autocomplete(user_address, { types: ['geocode'] });
    google.maps.event.addListener(autocomplete, 'place_changed', onPlaceChanged);
    google.maps.event.addDomListener(user_address, 'keydown', function(e) {
      if (e.keyCode == 13) {
        e.preventDefault(); // Do not submit the form on Enter.
      }
    });
  }
});

function onPlaceChanged() {
  var place = this.getPlace();
  var components = getAddressComponents(place);

  $('#user_address').trigger('blur').val(components.address);
  $('#user_zip_code').val(components.zip_code);
  $('#user_city').val(components.city);
  if (components.country_code) {
    $('#user_country_code').val(components.country_code);
  }
  $('#user_state').val(components.state);
  $('#user_division').val(components.division);
}

function getAddressComponents(place) {
  // If you want lat/lng, you can look at:
  // - place.geometry.location.lat()
  // - place.geometry.location.lng()
  var street_number = null;
  var route = null;
  var zip_code = null;
  var city = null;
  var country_code = null;
  var state = null;
  var division = null;
  for (var i in place.address_components) {
    var component = place.address_components[i];
    for (var j in component.types) {
      var type = component.types[j];
      if (type == 'street_number') {
        street_number = component.long_name;
      } else if (type == 'route') {
        route = component.long_name;
      } else if (type == 'postal_code') {
        zip_code = component.long_name;
      } else if (type == 'locality') {
        city = component.long_name;
      } else if (type == 'country') {
        country_code = component.short_name;
      } else if (type == 'administrative_area_level_1') {
        state = component.short_name;
      } else if (type == 'administrative_area_level_2') {
        division = component.short_name;
      }
    }
  }

  return {
    address: street_number == null ? route : (street_number + ' ' + route),
    zip_code: zip_code,
    city: city,
    country_code: country_code,
    state: state,
    division: division
  };
}
