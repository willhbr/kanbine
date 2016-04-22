class Kanbine::IssuesController < ApplicationController
  def update_status_position
    issue = Issue.find(params[:id])
    up_issue = Issue.find_by_id(params[:up])
    down_issue = Issue.find_by_id(params[:down])
    status = IssueStatus.find(params[:status_id])

    pos = Kanbine::IssueOrder.new_position issue, up_issue, down_issue

    if pos.nil?
      issues = issue.project.issues.where(status_id: status.id).order(:kanban_position)
      if up_issue.nil?
        issue.update_column(:kanban_position, 0)
        pos = Kanbine::IssueOrder.rearrange issues, issue.id
      else
        pos =  Kanbine::IssueOrder.rearrange issues, up_issue.id
      end
    end

    issue.status = status
    issue.kanban_position = pos
    issue.save
    render json: issue
  end
end
