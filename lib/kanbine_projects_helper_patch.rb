require_dependency 'projects_helper'

module Kanbine
  module ProjectsHelperPatch
    def self.included(base)
      base.class_eval do
        def project_settings_tabs_with_kanbine
          tabs = project_settings_tabs_without_kanbine
          tabs << {
            :name => 'kanbine',
            :action => :configure_kanbine,
            :partial => 'kanbine/project_settings',
            :label => :label_kanbine
          } if User.current.allowed_to?(:configure_kanbine, @project)
          return tabs
        end
        alias_method_chain :project_settings_tabs, :kanbine
      end
    end
  end
end

unless ProjectsHelper.included_modules.include? Kanbine::ProjectsHelperPatch
  ProjectsHelper.send(:include, Kanbine::ProjectsHelperPatch)
end
