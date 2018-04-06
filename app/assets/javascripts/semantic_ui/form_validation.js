// formバリデーション
// Semantic UI Form Validation Document: https://semantic-ui.com/behaviors/form.html

$(document).on('turbolinks:load', function() {
  $('.ui.form').form({
    fields: {
      'recruitment[title]': {
        rules: [
          {
            type: 'maxLength[100]',
            prompt : '[タイトル] 100文字以下で入力してください。'
          },
          {
            type: 'empty',
            prompt : '[タイトル] 入力必須です。'
          },
        ]
      },
      'recruitment[description]': {
        rules: [
          {
            type: 'maxLength[5120]',
            prompt: '[募集内容] 5120文字以下で入力してください。'
          },
          {
            type: 'empty',
            prompt: '[募集内容] 入力必須です。'
          }
        ]
      },
      'recruitment[prefecture_code]': {
        rules: [
          {
            type: 'empty',
            prompt: '[都道府県] 入力必須です。'
          }
        ]
      },
      'recruitment[event_date]': {
        rules: [
          {
            type: 'empty',
            prompt: '[開催日] 入力必須です。'
          }
        ]
      },
      'message[message]': {
        rules: [
          {
            type: 'maxLength[1024]',
            prompt : '1024文字以下で入力してください。'
          },
          {
            type: 'empty',
            prompt : '入力必須です。'
          }
        ]
      },
      'user[email]': {
        rules: [
          {
            type: 'empty',
            prompt: '[メールアドレス] 入力必須です。'
          },
          {
            type: 'regExp',
            value: /[^@\s]+@[^@\s]+/i,
            prompt: '[メールアドレス] 形式が正しくありません。'
          }
        ]
      },
      'user[password]': {
        rules: [
          {
            type: 'empty',
            prompt: '[パスワード] 入力必須です。'
          },
          {
            type: 'minLength[6]',
            prompt : '[パスワード] 6文字以上で入力してください。'
          },
          {
            type: 'maxLength[128]',
            prompt : '[パスワード] 128文字以下で入力してください。'
          },
        ]
      },
      'user[current_password]': {
        rules: [
          {
            type: 'empty',
            prompt: '[現在のパスワード] 入力必須です。'
          }
        ]
      },
      'user[password_confirmation]': {
        rules: [
          {
            type: 'empty',
            prompt: '[新しいパスワード（再入力）] 入力必須です。'
          }
        ]
      },
      'user[name]': {
        rules: [
          {
            type: 'maxLength[16]',
            prompt : '[ユーザー名] 16文字以下で入力してください。'
          },
          {
            type: 'empty',
            prompt : '[ユーザー名] 入力必須です。'
          },
        ]
      },
      'user[introduction]': {
        rules: [
          {
            type: 'maxLength[5120]',
            prompt : '[自己紹介文] 5120文字以下で入力してください。'
          }
        ]
      },
      'user[experience]': {
        rules: [
          {
            type: 'maxLength[32]',
            prompt : '[ナンパ歴] 32文字以下で入力してください。'
          }
        ]
      },
      'user[image]': {
        rules: [
          {
            type: 'empty',
            prompt: '画像を選択してください。'
          }
        ]
      },
      'blog_article[title]': {
        rules: [
          {
            type: 'maxLength[128]',
            prompt : '[タイトル] 128文字以下で入力してください。'
          },
          {
            type: 'empty',
            prompt : '[タイトル] 入力必須です。'
          },
        ]
      },
      'blog_article[content]': {
        rules: [
          {
            type: 'maxLength[4096]',
            prompt : '[本文] 4096文字以下で入力してください。'
          },
          {
            type: 'empty',
            prompt : '[本文] 入力必須です。'
          },
        ]
      },
      'blog_comment[content]': {
        rules: [
          {
            type: 'maxLength[512]',
            prompt : '[本文] 512文字以下で入力してください。'
          },
          {
            type: 'empty',
            prompt : '[本文] 入力必須です。'
          },
        ]
      },
    }
  });
});
