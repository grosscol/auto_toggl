require 'yaml'

class Settings
  @@profiles 

  def self.profiles
    @@profiles ||= parse_config_file
  end

  private

  def self.parse_config_file
    path = File.expand_path('../../config/auto_toggl.yml', __FILE__) 
    cfg = YAML.load_file(path)
    cfg['profiles']
  end
end
