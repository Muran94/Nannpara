$(document).on('turbolinks:load', function() {
  $("#prefecture-select").click(function() {
    $(".ui.modal").modal({
      centered: false,
      autofocus: false
    }).modal("show");
  });

  $('[name="recruitment[prefecture_code]"]').change(function() {
    var selected_prefecture_code = $('[name="recruitment[prefecture_code]"] option:selected').val();
    if (selected_prefecture_code.match(/^(8|9|10|11|12|13|14)$/)) {
      $("#recruitment_linked_with_kanto_nanpa_messageboard").val(true);
      $("#linked-with-kanto-nanpa-messageboard-field").removeClass("hidden");
      $("#kanto-nanpa-messageboard-delete-key-field").removeClass("hidden");
    } else {
      $("#recruitment_linked_with_kanto_nanpa_messageboard").val(false);
      $("#linked-with-kanto-nanpa-messageboard-field").addClass("hidden");
      $("#kanto-nanpa-messageboard-delete-key-field").addClass("hidden");
    }
  });

  $('.ui.dropdown').dropdown();
});
