require 'rails_helper'

RSpec.describe BlogArticlesController, type: :controller do
  describe 'GET #index' do
    let(:titles) do
      {
        first: 'first_blog',
        second: 'second_blog',
        third: 'third_blog'
      }
    end
    let!(:blog_articles) do
      [
        create(:blog_article, title: titles[:first], created_at: 1.day.ago),
        create(:blog_article, title: titles[:second], created_at: 2.day.ago),
        create(:blog_article, title: titles[:third], created_at: 3.day.ago)
      ]
    end

    before { get :index }

    context 'レスポンス' do
      it 'ステータスコード200を返却  && indexテンプレートをrender' do
        aggregate_failures do
          expect(response).to have_http_status 200
          expect(response).to render_template :index
        end
      end
    end

    context 'インスタンス変数' do
      it '@blog_articlesに正しい順番でコレクションがセットされている' do
        aggregate_failures do
          expect(assigns(:blog_articles).count).to eq 3
          expect(assigns(:blog_articles)).to eq blog_articles
        end
      end
    end
  end

  describe 'GET #show' do
    let(:blog_article) { create(:blog_article) }
    let(:blog_comments) do
      [
        create(:blog_comment, blog_article: blog_article, created_at: 1.day.ago),
        create(:blog_comment, blog_article: blog_article, created_at: 2.day.ago),
        create(:blog_comment, blog_article: blog_article, created_at: 3.day.ago)
      ]
    end
    let(:params) { { id: blog_article.id } }

    before { get :show, params: params }

    context 'レスポンス' do
      it 'ステータスコード200を返却  && showテンプレートをrender' do
        aggregate_failures do
          expect(response).to have_http_status 200
          expect(response).to render_template :show
        end
      end
    end

    context 'インスタンス変数' do
      it '@blog_articleに正しい値がセットされている' do
        expect(assigns(:blog_article)).to eq blog_article
        expect(assigns(:blog_comments)).to eq blog_comments
        expect(assigns(:new_blog_comment)).to be_a_new(BlogComment)
      end
    end
  end

  describe 'GET #new' do
    context 'ログイン済み' do
      let(:user) { create(:user) }

      before do
        sign_in user
        get :new
      end

      context 'レスポンス' do
        it 'レスポンスコード200を返却 && newテンプレートをrender' do
          aggregate_failures do
            expect(response).to have_http_status 200
            expect(response).to render_template :new
          end
        end
      end

      context 'インスタンス変数' do
        it '@blog_articleに正しいユーザーIDを持つBlogArticleの新インスタンスが代入されている' do
          aggregate_failures do
            expect(assigns(:blog_article)).to be_a_new BlogArticle
            expect(assigns(:blog_article).user_id).to eq user.id
          end
        end
      end
    end

    context '未ログイン' do
      before { get :new }

      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'POST #create' do
    let(:params) do
      {
        blog_article: {
          title: title,
          content: '心理学の勉強をしましょう！そして堂々とした態度で接しましょう！'
        }
      }
    end

    context 'ログイン済み' do
      let(:user) { create(:user) }

      before { sign_in user }

      context '正常系' do
        let(:title) { 'ナンパの極意教えます' }

        it 'ブログ記事の作成に成功し、正しいflash[:success]メッセージとともにブログの詳細ページにリダイレクトされる' do
          aggregate_failures do
            expect { post :create, params: params }.to change(BlogArticle, :count).by(1)
            expect(flash[:success]).to eq 'ブログの投稿が完了しました。'
            expect(response).to redirect_to blog_article_path(assigns(:blog_article))
          end
        end
      end

      context '異常系' do
        let(:title) { 'あ' * (BlogArticle::MAXIMUM_TITLE_LENGTH + 1) }

        it 'バリデーションに引っかかった場合は、ブログ記事が作成されず、正しいflash[:error]メッセージとともにnewテンプレートがrenderされる' do
          aggregate_failures do
            expect { post :create, params: params }.not_to change(BlogArticle, :count)
            expect(flash[:error]).to eq 'ブログの投稿に失敗しました。'
            expect(response).to render_template :new
          end
        end
      end
    end

    context '未ログイン' do
      let(:title) { 'ナンパって難しいですね。' }

      before { post :create, params: params }

      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:blog_article) { create(:blog_article, user: user) }
    let(:params) { { id: blog_article.id } }

    context 'ログイン済み' do
      context 'ブログ記事のオーナーである' do
        before do
          sign_in user
          get :edit, params: params
        end

        context 'レスポンス' do
          it 'ステータスコード200を返却  && editテンプレートをrender' do
            aggregate_failures do
              expect(response).to have_http_status 200
              expect(response).to render_template :edit
            end
          end
        end

        context 'インスタンス変数' do
          it '@blog_articleに正しいインスタンス変数がセットされている' do
            aggregate_failures do
              expect(assigns(:blog_article)).to eq blog_article
            end
          end
        end
      end

      context 'ブログ記事のオーナーでない' do
        before do
          sign_in other_user
          get :edit, params: params
        end

        context 'レスポンス' do
          it '不正な操作に対しては、正しいflash[:error]メッセージとともに、ブログ記事一覧ページにリダイレクトされる' do
            aggregate_failures do
              expect(flash[:error]).to eq '不正な操作です。もう一度最初からやり直してください。'
              expect(response).to redirect_to blog_articles_path
            end
          end
        end
      end
    end

    context '未ログイン' do
      before { post :create, params: params }

      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'PATCH/PUT #update' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:blog_article) { create(:blog_article, user: user, title: blog_article_before_title) }
    let(:blog_article_before_title) { '本日新宿にてナンパをしてきました！' }
    let(:blog_article_after_title) { '本日新宿にてナンパをしてきました！（更新済み）' }
    let(:params) do
      {
        id: blog_article.id,
        blog_article: {
          title: blog_article_after_title,
          content: '詳しくはまた後日お話しします。'
        }
      }
    end

    context 'ログイン済み' do
      context 'ブログ記事のオーナーである' do
        before do
          sign_in user
          patch :update, params: params
        end

        context '正常系' do
          it 'ブログ記事の更新に成功し、正しいflash[:success]メッセージとともにブログ詳細ページにリダイレクトされること' do
            aggregate_failures do
              blog_article.reload
              expect(blog_article.title).to eq blog_article_after_title
              expect(flash[:success]).to eq 'ブログの更新が完了しました。'
              expect(response).to redirect_to blog_article_path(blog_article)
            end
          end
        end

        context '異常系' do
          let(:blog_article_after_title) { 'あ' * (BlogArticle::MAXIMUM_CONTENT_LENGTH + 1) }

          it 'バリデーションに引っかかった場合は、ブログ記事が更新に失敗し、正しいflash[:error]メッセージとともにeditテンプレートがrenderされる' do
            aggregate_failures do
              blog_article.reload
              expect(blog_article.title).to eq blog_article_before_title
              expect(flash[:error]).to eq 'ブログの更新に失敗しました。'
              expect(response).to render_template :edit
            end
          end
        end
      end

      context 'ブログ記事のオーナーでない' do
        before do
          sign_in other_user
          patch :update, params: params
        end

        it '不正な操作に対しては、正しいflash[:error]メッセージとともに、ブログ記事一覧ページにリダイレクトされる' do
          aggregate_failures do
            expect(flash[:error]).to eq '不正な操作です。もう一度最初からやり直してください。'
            expect(response).to redirect_to blog_articles_path
          end
        end
      end
    end

    context '未ログイン' do
      before { patch :update, params: params }

      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:blog_article) { create(:blog_article, user: user) }
    let(:params) { { id: blog_article.id } }

    context 'ログイン済み' do
      context 'ブログ記事のオーナーである' do
        before { sign_in user }

        it 'ブログ記事の削除に成功し、正しいflash[:success]メッセージとともにブログ記事一覧ページにリダイレクトされること' do
          aggregate_failures do
            expect { delete :destroy, params: params }.to change(BlogArticle, :count).by(-1)
            expect(flash[:success]).to eq 'ブログ記事の削除が完了しました。'
            expect(response).to redirect_to blog_articles_path
          end
        end
      end

      context 'ブログ記事のオーナーでない' do
        before do
          sign_in other_user
          delete :destroy, params: params
        end

        it '不正な操作に対しては、正しいflash[:error]メッセージとともに、ブログ記事一覧ページにリダイレクトされる' do
          aggregate_failures do
            expect(flash[:error]).to eq '不正な操作です。もう一度最初からやり直してください。'
            expect(response).to redirect_to blog_articles_path
          end
        end
      end
    end

    context '未ログイン' do
      before { delete :destroy, params: params }

      it 'ログインページにリダイレクトされる' do
        aggregate_failures do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
