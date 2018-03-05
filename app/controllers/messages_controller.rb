class MessagesController < ApplicationController
  before_action :_get_recruitment, only: [:create]

  def create
    @message = @recruitment.messages.build(_message_params)
    @message.user_id = current_user.id
    if @message.save
      flash[:success] = "メッセージの送信に成功しました。"
      redirect_to @recruitment
    else
      flash[:alert] = "メッセージの送信に失敗しました。"
      render "recruitments/new"
    end
  end

  private

  def _get_recruitment
    @recruitment = Recruitment.find(params[:recruitment_id])
  end

  def _message_params
    params.require(:message).permit(:message)
  end
end
