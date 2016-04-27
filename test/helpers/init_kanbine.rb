module Helpers
  def init_kanbine(proj)
    proj.kanban_statuses = IssueStatus.where.not(name: ['Feedback', 'Rejected', 'Resolved']).all
    proj.kanban_trackers = Tracker.all
    proj.enable_module! 'kanbine'
  end
end
