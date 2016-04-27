class Kanbine::SettingsController < ApplicationController
  before_filter :find_project, :authorize

  def settings
    settings = params[:kanbine_settings]
    @project.kanban_status_ids = settings[:kanban_status_ids]
    @project.kanban_tracker_ids = settings[:kanban_tracker_ids]
    sets = @project.kanbine_settings
    sets.color_tag_group_id = settings[:color_tag_group_id]
    sets.issue_limit = settings[:issue_limit]
    sets.save

    flash[:notice] = 'Settings updated'
    redirect_to "/projects/#{@project.identifier}/settings/kanbine"
  end
end
