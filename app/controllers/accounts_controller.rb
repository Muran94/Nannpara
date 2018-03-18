class AccountsController < ApplicationController
  before_action :_set_user, only: [:profile, :recruitments]
  before_action :_set_current_user, only: [:edit, :update, :edit_password, :update_password]
  before_action :authenticate_user!, except: [:profile, :recruitments]
  # before_action :_account_owner?, except: [:show]

  # GET /accounts/1/profile
  def profile; end

  # GET /accounts/1/recruitments
  def recruitments
    @recruitments = @user.recruitments.order('created_at DESC').page(params[:page])
  end

  # GET /accounts/edit
  def edit
    @current_user = current_user
  end

  # PATCH/PUT /accounts
  def update
    @current_user = current_user
    if @current_user.update(_user_profile_params)
      flash[:success] = 'プロフィール更新が完了しました。'
      redirect_to profile_account_path(@current_user)
    else
      flash[:error] = 'プロフィール更新に失敗しました。'
      render :edit
    end
  end

  # GET /accounts/edit_password
  def edit_password
    @current_user = current_user
  end

  # PATCH/PUT /accounts/update_password
  def update_password
    @current_user = current_user
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
    params.require(:user).permit(:image, :introduction, :age, :prefecture_code, :experience)
  end

  def _user_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
