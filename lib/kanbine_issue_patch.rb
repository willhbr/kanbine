module Kanbine
  module IssuePatch
    def self.included(base)
      base.class_eval do
        def kanban_color_id
          if respond_to? :tags
            tag = tags(self.project.kanbine_settings.color_tag_group_id).first
            tag.nil? ? '' : tag.id
          elsif respond_to? :theme_id
            self.theme_id
          else
            ''
          end
        end
      end
    end
  end
end

unless Issue.included_modules.include? Kanbine::IssuePatch
  Issue.send(:include, Kanbine::IssuePatch)
end
