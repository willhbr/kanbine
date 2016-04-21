module Kanbine
  module ProjectPatch
    def self.included(base)
      base.class_eval do
        has_and_belongs_to_many :kanban_statuses, {
          class_name: 'IssueStatus',
          join_table: :project_kanban_statuses
        }
      end
    end
  end
end

unless Project.included_modules.include? Kanbine::ProjectPatch
  Project.send(:include, Kanbine::ProjectPatch)
end
