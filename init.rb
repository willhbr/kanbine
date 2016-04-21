Dir[File.expand_path(File.dirname(__FILE__) + '/lib/kanbine_*.rb')].each do |file|
  require_dependency file.split('/').last.chomp('.rb')
end

Redmine::Plugin.register :kanbine do
  name 'Kanbine plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
