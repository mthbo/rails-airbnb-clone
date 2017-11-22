function durationSlider() {

  var $dealDuration = $('#deal_duration');
  var $dealAmount = $('#deal_amount');

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
      $(this).addClass('hidden');
      $toHourlySliderBtn.removeClass('hidden');
      durationSlider.slider('destroy');
      durationSlider = setDailySlider();
      setSuggestedAmount(durationSlider);
    })

    $toHourlySliderBtn.on('click', function() {
      $(this).addClass('hidden');
      $toDailySliderBtn.removeClass('hidden');
      durationSlider.slider('destroy');
      durationSlider = setHourlySlider();
      setSuggestedAmount(durationSlider);
    })

  }

  if ($dealAmount.length > 0 ) {
    var $freeBtn = $('#deal-amount-free-btn');
    var $amountPlusBtn = $('#deal-amount-plus');
    var $amountMinusBtn = $('#deal-amount-minus');

    if (!isMobile()) {
      $freeBtn.tooltip({
        trigger: 'hover',
        placement: 'bottom'
      });
    }

    $freeBtn.on('click', function() {
      clearAmount($dealAmount);
    });

    $amountPlusBtn.on('click', function() {
      increaseAmount($dealAmount);
    });

    $amountMinusBtn.on('click', function() {
      decreaseAmount($dealAmount);
    });
  }

};

function setHourlySlider() {
  var hours = I18n.t('hours_short');
  var hourlySlider = $('#deal_duration').slider({
    ticks_labels: ["1 " + hours, "2 " + hours, "3 " + hours],
    min: 30,
    max: 210,
    step: 30,
    tooltip: "hide"
  });
  setDurationValue(hourlySlider);
  hourlySlider.on('change', function() {
    setDurationValue($(this));
    setSuggestedAmount($(this));
  });
  return hourlySlider;
}

function setDailySlider() {
  var days = I18n.t('days_short');
  var dailySlider = $('#deal_duration').slider({
    ticks_labels: ["1 " + days, "2 " + days, "3 " + days, "4 " + days, "5 " + days],
    min: 240,
    max: 2640,
    step: 240,
    tooltip: "hide"
  });
  setDurationValue(dailySlider);
  dailySlider.on('change', function() {
    setDurationValue($(this));
    setSuggestedAmount($(this));
  });
  return dailySlider;
}

function setDurationValue(slider) {
  var sliderValue = slider.slider('getValue');
  var daysValue = Math.floor( sliderValue * 10 / 480) / 10;
  var hoursValue = Math.floor( sliderValue / 60);
  var minutesValue = ("0" + (sliderValue % 60)).slice(-2);
  var days = I18n.t('days', {count: daysValue});
  var hours = I18n.t('hours_short');
  var minutes = I18n.t('minutes_short');
  var duration = "";
  var durationSymbol = "<i class='fa fa-clock-o medium-dark-gray' aria-hidden='true'></i>&nbsp;&nbsp; ";
  if (sliderValue < 60) {
    duration = minutesValue + ' ' + minutes;
  } else if (sliderValue < 240) {
    duration = hoursValue + ' ' + hours + ' ' + minutesValue;
  } else {
    duration = daysValue.toLocaleString(I18n.locale) + ' ' + days;
    durationSymbol = "<i class='fa fa-calendar medium-dark-gray' aria-hidden='true'></i>&nbsp;&nbsp; "
  }
  $('#deal-slider-duration-display').html(durationSymbol + duration);
}

function setSuggestedAmount(slider) {
  var sliderValue = slider.slider('getValue');
  var suggestedAmount = sliderValue / 30 * 10;
  var maxAmount = suggestedAmount * 2;
  $('#deal_amount').val(suggestedAmount.toLocaleString(I18n.locale));
  $('#deal_amount').attr('max', maxAmount);
}

function clearAmount($dealAmount) {
  $dealAmount.val("");
}

function increaseAmount($dealAmount) {
  var currentAmount = parseInt($dealAmount.val());
  var minAmount = $dealAmount.attr('min');
  var maxAmount = $dealAmount.attr('max');
  if (!isNaN(currentAmount)) {
    if(currentAmount < maxAmount) {
      $dealAmount.val(currentAmount + 1).change();
    }
    if(currentAmount == maxAmount) {
      $(this).attr('disabled', true);
    }
  }
}

function decreaseAmount($dealAmount) {
  var currentAmount = parseInt($dealAmount.val());
  var minAmount = $dealAmount.attr('min');
  var maxAmount = $dealAmount.attr('max');
  if (!isNaN(currentAmount)) {
    if(currentAmount > minAmount) {
      $dealAmount.val(currentAmount - 1).change();
    }
    if(currentAmount == minAmount) {
      $(this).attr('disabled', true);
    }
  }
}

$(document).ready(durationSlider());
