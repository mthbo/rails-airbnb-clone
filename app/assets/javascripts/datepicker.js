function datePicker () {

  $('.datepicker').datepicker({
      weekStart: 1,
      format: 'dd M yyyy',
      todayHighlight: true,
      autoclose: true,
  })
};

$(document).ready(datePicker());
