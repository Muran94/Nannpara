$(document).on('turbolinks:load', function() {
  $("#prefecture-select").click(function() {
    $(".ui.modal").modal("show");
  });
  $('.ui.dropdown').dropdown();
});
