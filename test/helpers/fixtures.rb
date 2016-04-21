module Helpers
  def load_fixtures(*names)
    path = File.expand_path(File.dirname(__FILE__) + '/../fixtures')
    get_fixtures path, names
  end
  def core_fixtures(*names)
    path = File.expand_path(File.dirname(__FILE__) + '/../../../../test/fixtures')
    get_fixtures path, names
  end

  private
  def get_fixtures(path, names)
    if names.include? :all
      names = Dir[path + '/*.yml'].map { |f| f.split('/')[-1].split('.')[0].to_sym }
    end
    names.each do |name|
      ActiveRecord::FixtureSet.create_fixtures(path, name)
    end
  end
end
