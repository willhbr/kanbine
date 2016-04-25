class Kanbine::IssuesController < ApplicationController
  def update_status_position
    issue = Issue.find(params[:id])
    up_issue = Issue.find_by_id(params[:up])
    down_issue = Issue.find_by_id(params[:down])
    status = IssueStatus.find(params[:status_id])

    pos = Kanbine::IssueOrder.new_position issue, up_issue, down_issue

    if pos.nil?
      if up_issue != nil && up_issue.kanban_position != nil && down_issue == nil # Moving to the bottom
        pos = up_issue.kanban_position + Kanbine::IssueOrder::POSITION_GAP
      else
        issues = issue.project.issues.where(status_id: status.id).order(:kanban_position)
        if up_issue.nil? # Rearrange the whole lot
          Kanbine::IssueOrder.rearrange issues, start_position: Kanbine::IssueOrder::POSITION_GAP
          pos = Kanbine::IssueOrder::START_POSITION
        else
          pos = Kanbine::IssueOrder.rearrange issues, get_position_after: up_issue.id
        end
      end
    end

    issue.status = status
    issue.kanban_position = pos
    issue.save!
    render json: issue
  end
end
