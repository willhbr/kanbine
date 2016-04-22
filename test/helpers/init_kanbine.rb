module Helpers
  def init_kanbine(proj)
    proj.kanban_statuses = IssueStatus.where.not(name: ['Feedback', 'Rejected', 'Resolved']).all
  end
end
