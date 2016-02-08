//= require jquery-ui/sortable
//= require selectize
//= require_directory .

$(function () {
  $(".select2").selectize({plugins: ['remove_button'], closeAfterSelect: true });

  $(".applicable-nations input[type='checkbox']").click(function() {
    $('.js-alternative-policy-url#' + $(this).data('nation')).toggle();
  });
});
