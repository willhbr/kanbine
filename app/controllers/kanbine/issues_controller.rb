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

    if issue.save
      render json: {
        saved: true,
        new_position: issue.kanban_position
      }
    else
      render json: {
        saved: false,
        errors: issue.errors.full_messages
      }
    end
  end

  def create
    issue = Issue.new(issue_params)
    issue.author = User.current
    issue.project_id = params[:project_id]
    if issue.save
      html = render_to_string partial: 'kanban/issue_row', locals: { issue: issue }, layout: false
      render json: {
        saved: true,
        html: html
      }
    else
      render json: {
        saved: false,
        errors: issue.errors.full_messages
      }
    end
  end

  def update
    issue = Issue.find(params[:issue_id])

    attrs = issue_params
    # The status ID is likely blank (we only use the field for create) so remove
    # it so the field isn't blanked out
    if attrs[:status_id].blank? || attrs[:status_id].to_i == 0
      attrs.delete :status_id
    end
    issue.init_journal(User.current)
    if issue.update_attributes(issue_params)
      html = render_to_string partial: 'kanban/issue_row', locals: { issue: issue }, layout: false
      render json: {
        saved: true,
        html: html
      }
    else
      render json: {
        saved: false,
        errors: issue.errors.full_messages
      }
    end
  end

  def issue_params
    params.require(:issue).permit!
  end
end
