class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end

  def destroy
    team_members = @agenda.team.members
    if current_user.id != @agenda.user_id && current_user.id != @agenda.team.owner_id
      redirect_to dashboard_url, notice: "agendaの作成者またはチーム管理者のみ削除できます。"
    elsif @agenda.destroy
      team_members.each do | member |
        DeleteMailer.delete_mail(member.email).deliver
      end
      redirect_to dashboard_url, notice: I18n.t('views.messages.delete_agenda')
    else
      redirect_to dashboard_url, notice: '削除に失敗しました。'
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
