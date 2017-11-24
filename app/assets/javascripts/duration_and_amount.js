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
    var durationSlider = durationValue < 240 ? setHourlySlider() : setDailySlider();
    setDurationValue(durationSlider);
    bindDurationSlider(durationSlider);

    $toDailySliderBtn.on('click', function() {
      $(this).addClass('hidden');
      $toHourlySliderBtn.removeClass('hidden');
      durationSlider.slider('destroy');
      durationSlider = setDailySlider();
      setDurationValue(durationSlider);
      setAmountValues(durationSlider);
      bindDurationSlider(durationSlider);
    })

    $toHourlySliderBtn.on('click', function() {
      $(this).addClass('hidden');
      $toDailySliderBtn.removeClass('hidden');
      durationSlider.slider('destroy');
      durationSlider = setHourlySlider();
      setDurationValue(durationSlider);
      setAmountValues(durationSlider);
      bindDurationSlider(durationSlider);
    })

  }
};

function dealAmountInput() {

  var $dealAmount = $('#deal_amount');
  if ($dealAmount.length > 0 ) {
    var $freeBtn = $('#deal-amount-free-btn');
    var $amountBtns = $('.deal-amount-btn');
    setAmountColor($dealAmount);

    if (!isMobile()) {
      $freeBtn.tooltip({
        trigger: 'hover',
        placement: 'bottom'
      });
    }

    $freeBtn.on('click', function() {
      clearAmount($dealAmount);
    });

    $amountBtns.on('click', function() {
      setAmount($(this), $dealAmount);
    });

    $dealAmount.on('change', function() {
      checkAmount($(this));
    })

    $dealAmount.on('keydown', function(event) {
      if (event.keyCode === 13) {
        event.preventDefault();
        checkAmount($(this));
        $(this).blur();
      }
    })

  }
}

function setHourlySlider() {
  var hours = I18n.t('hours_short');
  var hourlySlider = $('#deal_duration').slider({
    ticks_labels: ["1 " + hours, "2 " + hours, "3 " + hours],
    min: 30,
    max: 210,
    step: 30,
    tooltip: "hide"
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
  return dailySlider;
}

function bindDurationSlider(slider) {
  slider.on('change', function() {
    setDurationValue($(this));
    setAmountValues($(this));
  });
}

function setDurationValue(slider) {
  var durationMinutes = slider.slider('getValue');
  var daysValue = Math.floor(durationMinutes * 10 / 480) / 10;
  var hoursValue = Math.floor(durationMinutes / 60);
  var minutesValue = ("0" + (durationMinutes % 60)).slice(-2);
  var days = I18n.t('days', {count: daysValue});
  var hours = I18n.t('hours_short');
  var minutes = I18n.t('minutes_short');
  var duration = "";
  var durationSymbol = "<i class='fa fa-clock-o medium-dark-gray' aria-hidden='true'></i>&nbsp;&nbsp; ";
  if (durationMinutes < 60) {
    duration = minutesValue + ' ' + minutes;
  } else if (durationMinutes < 240) {
    duration = hoursValue + ' ' + hours + ' ' + minutesValue;
  } else {
    duration = daysValue.toLocaleString(I18n.locale) + ' ' + days;
    durationSymbol = "<i class='fa fa-calendar medium-dark-gray' aria-hidden='true'></i>&nbsp;&nbsp; "
  }
  $('#deal-slider-duration-display').html(durationSymbol + duration);
}

function setAmountValues(slider) {
  var duration = slider.slider('getValue');
  var minAmount = $('#deal_amount').attr('min');
  var amountRatio = parseInt($('#deal_amount').data('ratio'));
  var suggestedAmount = duration * minAmount / 30;
  var maxAmount = duration * minAmount * amountRatio / 30;
  var $dealAmount = $('#deal_amount');
  $dealAmount.val(suggestedAmount.toLocaleString(I18n.locale));
  $dealAmount.data('suggested', suggestedAmount);
  $dealAmount.attr('max', maxAmount);
  setAmountColor($dealAmount);
}

function clearAmount($dealAmount) {
  $dealAmount.val("");
  setAmountColor($dealAmount);
}

function setAmount($amountBtn, $dealAmount) {
  var btnType = $amountBtn.attr('name');
  var currentAmount = parseInt($dealAmount.val());
  var minAmount = $dealAmount.attr('min');
  var maxAmount = $dealAmount.attr('max');
  var suggestedAmount = $dealAmount.data('suggested');
  if (!isNaN(currentAmount)) {
    if (currentAmount < minAmount || currentAmount > maxAmount) {
      $dealAmount.val(suggestedAmount);
    } else if ( btnType === "plus-btn" && currentAmount < maxAmount ) {
      $dealAmount.val(currentAmount + 1);
    } else if ( btnType === "minus-btn" && currentAmount > minAmount ) {
      $dealAmount.val(currentAmount - 1);
    } else {
      $(this).attr('disabled', true);
    }
  } else {
    $dealAmount.val(suggestedAmount);
  }
  setAmountColor($dealAmount);
}

function checkAmount($dealAmount) {
  var currentAmount = parseInt($dealAmount.val());
  var minAmount = $dealAmount.attr('min');
  var maxAmount = $dealAmount.attr('max');
  var suggestedAmount = $dealAmount.data('suggested');
  if (!isNaN(currentAmount)) {
    if (currentAmount < minAmount || currentAmount > maxAmount) {
      $dealAmount.val(suggestedAmount);
    }
  } else if ($dealAmount.val() !== "") {
    $dealAmount.val(suggestedAmount);
  }
  setAmountColor($dealAmount);
}

function setAmountColor($dealAmount) {
  var currentAmount = parseInt($dealAmount.val());
  var suggestedAmount = $dealAmount.data('suggested');
  if (!isNaN(currentAmount)) {
    if (currentAmount > suggestedAmount) {
      $dealAmount.css('color', '#EE5F5B');
    } else if (currentAmount < suggestedAmount) {
      $dealAmount.css('color', '#42D3AA');
    } else {
      $dealAmount.css('color', 'rgb(74,74,74)');
    }
  } else {
    $dealAmount.css('color', 'rgb(74,74,74)');
  }
}

$(document).ready(durationSlider());
$(document).ready(dealAmountInput());
