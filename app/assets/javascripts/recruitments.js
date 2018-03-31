$(document).on('turbolinks:load', function() {
  $("#prefecture-select").click(function() {
    $(".ui.modal").modal({
      centered: false,
      autofocus: false
    }).modal("show");
  });
  $('.ui.dropdown').dropdown();
});
