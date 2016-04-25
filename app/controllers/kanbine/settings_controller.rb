class Kanbine::SettingsController < ApplicationController
  before_filter :find_project, :authorize

  def settings
    @project.kanban_status_ids = params[:kanban_status_ids]
    @project.kanban_tracker_ids = params[:kanban_tracker_ids]

    redirect_to "/projects/#{@project.identifier}/settings/kanbine"
  end
end
