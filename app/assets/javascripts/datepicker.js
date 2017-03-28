function datePicker () {

  setLocale();
  $.fn.datepicker.dates['en']['format'] = 'yyyy-mm-dd';

  $('.datepicker').datepicker({
      weekStart: 1,
      todayHighlight: true,
      autoclose: true,
      language: I18n.locale
  })
};

$(document).ready(datePicker());
