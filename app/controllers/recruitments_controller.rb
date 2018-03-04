class RecruitmentsController < ApplicationController
  before_action :_get_recruitment, only: [:show, :edit, :update, :destroy]

  def index
    @recruitments = Recruitment.all.order("created_at DESC")
  end

  def show
  end

  def new
    @recruitment = Recruitment.new
  end

  def create
    @recruitment = current_user.recruitments.build(_recruitment_params)
    if @recruitment.save
      redirect_to @recruitment
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @recruitment.update(_recruitment_params)
      redirect_to @recruitment
    else
      render :edit
    end
  end

  def destroy
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
