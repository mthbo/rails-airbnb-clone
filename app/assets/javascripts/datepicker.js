function datePicker () {

  $('.datepicker').datepicker({
      startView: 'decade',
      weekStart: 1,
      format: 'dd M yyyy',
      todayHighlight: false,
      autoclose: true,
  })
};

$(document).ready(datePicker());
