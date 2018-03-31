class RecruitmentsController < ApplicationController
  before_action :_get_recruitment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :_redirect_unless_owner, only: [:edit, :update, :destroy]

  def index
    if params["search"].present? && params["search"]["prefecture_code"].present?
      @recruitments = Recruitment.where(prefecture_code: params["search"]["prefecture_code"].map(&:to_i).compact).order(:closed, :event_date).includes(:user).page(params[:page])
    else
      @recruitments = Recruitment.order(:closed, :event_date).includes(:user).page(params[:page])
    end
  end

  def show
    @messages = @recruitment.messages.includes(:user).order('created_at ASC').page(params[:page])
    @new_message = @recruitment.messages.build
  end

  def new
    @recruitment = Recruitment.new
  end

  def create
    @recruitment = current_user.recruitments.build(_recruitment_params)
    if @recruitment.save
      flash[:success] = '募集記事の作成が完了しました。'
      redirect_to @recruitment
    else
      flash[:error] = '募集記事の作成に失敗しました。'
      render :new
    end
  end

  def edit
  end

  def update
    if @recruitment.update(_recruitment_params)
      flash[:success] = '募集記事の更新が完了しました。'
      redirect_to @recruitment
    else
      flash[:error] = '募集記事の更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    @recruitment.destroy
    flash[:success] = '募集記事の削除が完了しました。'
    redirect_to root_path
  end

  private

  def _get_recruitment
    @recruitment = Recruitment.find(params[:id])
  end

  def _redirect_unless_owner
    unless @recruitment.user == current_user
      flash[:error] = "不正な操作です。もう一度最初からやり直してください。"
      redirect_to root_path
    end
  end

  def _recruitment_params
    params.require(:recruitment).permit(
      :title,
      :description,
      :event_date,
      :prefecture_code,
      :venue
    )
  end
end
