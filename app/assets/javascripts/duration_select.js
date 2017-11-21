function durationSlider() {

  var $dealDuration = $('#deal_duration');
  if ($dealDuration.length > 0 ) {

    var $toDailySliderBtn = $('#deal-slider-to-daily');
    var $toHourlySliderBtn = $('#deal-slider-to-hourly');

    if (!isMobile()) {
      $toDailySliderBtn.tooltip({
        trigger: 'hover',
        placement: 'bottom'
      });
      $toHourlySliderBtn.tooltip({
        trigger: 'hover',
        placement: 'bottom'
      });
    }

    var durationValue = $dealDuration.data('slider-value');
    if (durationValue < 240) {
      var durationSlider = setHourlySlider();
    } else {
      var durationSlider = setDailySlider();
    }

    $toDailySliderBtn.on('click', function() {
      durationSlider.slider('destroy');
      durationSlider = setDailySlider();
      $(this).addClass('hidden');
      $toHourlySliderBtn.removeClass('hidden');
    })

    $toHourlySliderBtn.on('click', function() {
      durationSlider.slider('destroy');
      durationSlider = setHourlySlider();
      $(this).addClass('hidden');
      $toDailySliderBtn.removeClass('hidden');
    })

  }

};

function setHourlySlider() {
  var hourlySlider = $('#deal_duration').slider({
    ticks_labels: ["1 h", "2 h", "3 h"],
    min: 30,
    max: 210,
    step: 30,
    tooltip: "hide"
  });
  setDurationValue(hourlySlider);
  hourlySlider.on('change', function() {
    setDurationValue($(this));
  });
  return hourlySlider;
}

function setDailySlider() {
  var dailySlider = $('#deal_duration').slider({
    ticks_labels: ["1 j", "2 j", "3 j", "4 j", "5 j"],
    min: 240,
    max: 2640,
    step: 240,
    tooltip: "hide"
  });
  setDurationValue(dailySlider);
  dailySlider.on('change', function() {
    setDurationValue($(this));
  });
  return dailySlider;
}

function setDurationValue(slider) {
  var sliderValue = slider.slider('getValue');
  var days = Math.floor( sliderValue * 10 / 480) / 10;
  var hours = Math.floor( sliderValue / 60);
  var minutes = ("0" + (sliderValue % 60)).slice(-2);
  var duration = "";
  if (sliderValue < 60) {
    duration = minutes + " min"
  } else if (sliderValue < 240) {
    duration = hours + ' h ' + minutes;
  } else {
    duration = days + " jours"
  }
  $('#deal-slider-duration-display').text(duration);
}

$(document).ready(durationSlider());
