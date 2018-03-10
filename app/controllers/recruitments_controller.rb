class RecruitmentsController < ApplicationController
  before_action :_get_recruitment, only: [:show, :edit, :update, :destroy]

  def index
    @recruitments = Recruitment.all.order("created_at DESC")
  end

  def show
    @messages = @recruitment.messages.order("created_at DESC")
    @new_message = @recruitment.messages.build
  end

  def new
    @recruitment = Recruitment.new
  end

  def create
    @recruitment = current_user.recruitments.build(_recruitment_params)
    if @recruitment.save
      flash[:success] = "募集記事の作成が完了しました。"
      redirect_to @recruitment
    else
      flash[:alert] = "募集記事の作成に失敗しました。"
      render :new
    end
  end

  def edit
  end

  def update
    if @recruitment.update(_recruitment_params)
      flash[:success] = "募集記事の更新に完了しました。"
      redirect_to @recruitment
    else
      flash[:alert] = "募集記事の更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    flash[:success] = "募集記事の削除が完了しました。"
    @recruitment.delete
    redirect_to root_path
  end

  private

  def _get_recruitment
    @recruitment = Recruitment.find(params[:id])
  end

  def _recruitment_params
    params.require(:recruitment).permit(
      :title,
      :description,
      :event_date,
      :venue
    )
  end
end
