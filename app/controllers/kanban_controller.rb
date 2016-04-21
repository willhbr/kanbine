class KanbanController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @ordered_statuses = @project.kanban_statuses
    issues = @project.issues # TODO limit to a set of trackers/ issue statuses
    @issues = Hash.new
    @ordered_statuses.each do |status|
      @issues[status.id] = @project.issues.where(status_id: status.id).limit(15)
    end
  end
end
