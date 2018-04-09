$(document).on('turbolinks:load', function() {
  // common js
  $('.ui.dropdown').dropdown();

  // js for index page
  // 募集ページの都道府県絞り込み用モーダルの呼び出し処理
  $("#prefecture-select").click(function() {
    $(".ui.modal").modal({centered: false, autofocus: false}).modal("show");
  });

  // 募集リスト内の特定の募集をクリックした時に、詳細内容を表示するための処理
  $(".recruitment-information-open-territory").click(function () {
    $(this).closest(".recruitment-title-container").find(".go-to-icon").toggle();
    $(this).closest(".recruitment-list").find(".recruitment-information-container").slideToggle();
  });

  // js for show page

  // js for new page
  // 「関東ナンパ友募集掲示板」連携用フォームの呼び出し処理
  $('[name="recruitment[prefecture_code]"]').change(function () {
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

  // js for edit page
});
