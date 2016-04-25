class KanbanController < ApplicationController
  def show
    @project = Project.find(params[:id])
    version = (params[:version_id] && Version.find_by_id(params[:version_id])) || :all
    @ordered_statuses = @project.kanban_statuses.order(:position)
    @issues = Hash.new
    @ordered_statuses.each do |status|
      @issues[status.id] = @project.kanban_column(status, version).limit(15)
    end
    @version_id = version == :all ? nil : version.id
    @versions = @project.versions.open.visible.order(:effective_date).all
  end
end
