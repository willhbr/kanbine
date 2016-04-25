class KanbineSettings < ActiveRecord::Base
  belongs_to :project

  def self.create_with_defaults(project)
    KanbineSettings.create(
      project_id: project.id
    )
  end
end
