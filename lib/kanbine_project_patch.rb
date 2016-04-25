module Kanbine
  module ProjectPatch
    def self.included(base)
      base.class_eval do
        has_and_belongs_to_many :kanban_statuses, {
          class_name: 'IssueStatus',
          join_table: :project_kanban_statuses
        }

        has_and_belongs_to_many :kanban_trackers, {
          class_name: 'Tracker',
          join_table: :project_kanban_trackers
        }

        def kanban_column(status)
          status_id = status.is_a?(IssueStatus) ? status.id : status.to_i
          self.issues.where(tracker_id: kanban_tracker_ids, status_id: status_id).order(:kanban_position)
        end

        def kanbine_settings
          set = KanbineSettings.find_by_project_id(self.id)
          unless set
            set = KanbineSettings.create_with_defaults(self)
          end
          set
        end
      end
    end
  end
end

unless Project.included_modules.include? Kanbine::ProjectPatch
  Project.send(:include, Kanbine::ProjectPatch)
end
