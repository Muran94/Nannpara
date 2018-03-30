class AccountsController < ApplicationController
  before_action :_set_user, only: [:profile, :recruitments]
  before_action :_set_current_user, only: [:edit, :update, :edit_image, :update_image, :destroy_image, :edit_password, :update_password]
  before_action :authenticate_user!, except: [:profile, :recruitments]

  # GET /accounts/1/profile
  def profile; end

  # GET /accounts/1/recruitments
  def recruitments
    @recruitments = @user.recruitments.order('created_at DESC').page(params[:page])
  end

  # GET /accounts/edit
  def edit
  end

  # PATCH/PUT /accounts
  def update
    if @current_user.update(_user_profile_params)
      flash[:success] = 'プロフィール更新が完了しました。'
      redirect_to profile_account_path(@current_user)
    else
      flash[:error] = 'プロフィール更新に失敗しました。'
      render :edit
    end
  end

  # GET /accounts/edit_image
  def edit_image
  end

  # PATCH /accounts/update_image
  def update_image
    if @current_user.update(_user_image_params)
      flash[:success] = "プロフィール画像の変更が完了しました。"
    else
      flash[:error] = "プロフィール画像の変更に失敗しました。"
    end
    redirect_to profile_account_path(@current_user)
  end

  # PATCH/PUT /accounts/destroy_image
  def destroy_image
    @current_user.remove_image!
    if @current_user.save(validate: false)
      flash[:success] = "プロフィール画像の削除が完了しました。"
    else
      flash[:error] = "プロフィール画像の削除に失敗しました。"
    end
    redirect_to profile_account_path(@current_user)
  end

  # GET /accounts/edit_password
  def edit_password
  end

  # PATCH /accounts/update_password
  def update_password
    if @current_user.update_with_password(_user_password_params)
      bypass_sign_in(@current_user)
      flash[:success] = %(パスワード変更が完了しました。)
      redirect_to profile_account_path(@current_user)
    else
      flash[:error] = %(パスワード変更に失敗しました。)
      render :edit_password
    end
  end

  private

  def _set_user
    @user = User.find(params[:id])
  end

  def _set_current_user
    @current_user = current_user
  end

  def _user_profile_params
    params.require(:user).permit(:name, :image, :introduction, :age, :prefecture_code, :experience)
  end

  def _user_image_params
    params.require(:user).permit(:image)
  end

  def _user_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
