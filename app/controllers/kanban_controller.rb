class KanbanController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @ordered_statuses = @project.kanban_statuses.order(:position)
    @issues = Hash.new
    @ordered_statuses.each do |status|
      @issues[status.id] = @project.issues.where(status_id: status.id).order(:kanban_position).limit(15)
    end
  end
end
