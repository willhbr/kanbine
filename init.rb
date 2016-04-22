# Automatically load all ruby files in lib/ with 'kanbine' prefix
Dir[File.expand_path(File.dirname(__FILE__) + '/lib/kanbine_*.rb')].each do |file|
  require_dependency file.split('/').last.chomp('.rb')
end

Redmine::Plugin.register :kanbine do
  name 'Kanbine'
  author 'Will Richardson'
  description 'Kanban board for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://javanut.net'

  permission :kanban_it_up, {
    kanban: [
      :show
    ],
    'kanbine/issues' => [
      :update_status_position
    ]
  }

  menu :project_menu, :kanbine_kanban, {
    controller: :kanban,
    action: :show
  }, caption: :label_kanban, after: :roadmap

end
