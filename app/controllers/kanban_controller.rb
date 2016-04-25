class KanbanController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @ordered_statuses = @project.kanban_statuses.order(:position)
    @issues = Hash.new
    @ordered_statuses.each do |status|
      @issues[status.id] = @project.kanban_column(status).limit(15)
    end
  end
end
