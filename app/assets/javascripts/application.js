//= require select2
//= require_directory .

$(function () {
  $(".select2").select2();

  $(".applicable-nations input[type='checkbox']").click(function() {
    $('.js-alternative-policy-url#' + $(this).data('nation')).toggle();
  });
});
