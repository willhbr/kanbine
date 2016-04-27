class KanbanController < ApplicationController
  def show
    @project = Project.find(params[:id])
    version = (params[:version_id] && Version.find_by_id(params[:version_id])) || :all
    @ordered_statuses = @project.kanban_statuses.order(:position)
    @issues = Hash.new
    @overflow_count = 0
    issue_limit = @project.kanbine_settings.issue_limit
    issue_limit = nil if issue_limit.to_i <= 0

    @ordered_statuses.each do |status|
      @overflow_count += @project.kanban_column(status, version).count
      scope = @project.kanban_column(status, version)
      @issues[status.id] = issue_limit == nil ? scope.all : scope.limit(issue_limit)
      @overflow_count -= @issues[status.id].count
    end
    @version_id = version == :all ? nil : version.id
    @not_shown_count_statuses = @project.issues.where('status_id NOT IN (?)', @project.kanban_status_ids).count
    @not_shown_count_trackers = @project.issues.where('tracker_id NOT IN (?)', @project.kanban_tracker_ids).count
    @versions = @project.versions.open.visible.order(:effective_date).all
  end
end
