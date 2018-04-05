$(document).on('turbolinks:load', function() {
  $('.js-tweet-nice-button').on('ajax:success', function(event) {
    var $tweet_nice_button = $(this);
    var $tweet_nice_button_icon = $tweet_nice_button.children('i');
    var $tweet_nice_button_count_tag = $tweet_nice_button.children('.nice-count');

    var status = event.detail[0]['status'];

    switch (status) {
      case "created":
        // 「いいね」ボタンリンク参照先切り替えとデザイン変更
        $tweet_nice_button.attr({'data-method' : 'delete'});
        $tweet_nice_button_icon.addClass('orange');
        incrementNiceCount($tweet_nice_button_count_tag);
        break;
      case "unprocessable_entity":
        // @TODO
        // 「いいね」に失敗した旨をフラッシュメッセージで表示
        break;
      case "tweet_nice_duplicated":
        // @TODO
        // 既に「いいね」されている旨をフラッシュメッセージで表示
        break;
      case "deleted":
        // 「いいね」ボタンのリンク参照先切り替えとデザイン変更
        $tweet_nice_button.attr({'data-method' : 'post'})
        $tweet_nice_button_icon.removeClass('orange');
        decrementNiceCount($tweet_nice_button_count_tag);
        break;
      case "already_deleted":
        // @TODO
        // 既に「いいね」が解除されている旨をフラッシュメッセージで表示
        break;
    }

  }).on('ajax:error', function(event) {
    // @TODO
    // 通信処理に失敗した旨をフラッシュメッセージで表示
  });

  function incrementNiceCount($tweet_nice_button_count_tag) {
    var current_nice_count = $tweet_nice_button_count_tag.text();
    $tweet_nice_button_count_tag.text((current_nice_count * 1) + 1)
  }
  function decrementNiceCount($tweet_nice_button_count_tag) {
    var current_nice_count = $tweet_nice_button_count_tag.text();
    $tweet_nice_button_count_tag.text((current_nice_count * 1) - 1)
  }
});
