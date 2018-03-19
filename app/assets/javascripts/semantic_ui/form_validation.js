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
      'recruitment[venue]': {
        rules: [
          {
            type: 'maxLength[32]',
            prompt: '[開催場所] 32文字以下で入力してください。'
          },
          {
            type: 'empty',
            prompt: '[開催場所] 入力必須です。'
          }
        ]
      },
      'recruitment[event_date]': {
        rules: [
          {
            type: 'empty',
            prompt: '[開催日時] 入力必須です。'
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
          }
        ]
      },
      'user[password]': {
        rules: [
          {
            type: 'empty',
            prompt: '[パスワード] 入力必須です。'
          }
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
            prompt: '[現在のパスワード] 入力必須です。'
          }
        ]
      },
      'user[name]': {
        rules: [
          {
            type: 'maxLength[64]',
            prompt : '[ユーザー名] 64文字以下で入力してください。'
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
      }
    }
  });
});