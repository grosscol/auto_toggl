require 'yaml'

class Settings
  @@profiles 

  def self.profiles
    @@profiles ||= parse_config_file
  end

  def self.holidays
    @@holidays ||= parse_holidays_file
  end

  private

  def self.parse_config_file
    path = File.expand_path('../../config/auto_toggl.yml', __FILE__) 
    cfg = YAML.load_file(path)
    cfg['profiles']
  end

  def self.parse_holidays_file
    path = File.expand_path('../../config/umich_holidays.yml', __FILE__) 
    holi_hash = YAML.load_file(path)
    holidays = holi_hash['holidays']
  end
end
