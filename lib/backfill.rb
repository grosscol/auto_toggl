require 'togglv8'
require 'date'
require 'yaml'
require 'pry'


# Read the config
cfg = YAML.load_file('./config/auto_toggl.yml')
api_token = cfg["api_token"]
default_workspace_id = cfg["default_workspace_id"]
proj_id=cfg["default_project_id"]

# Have token or die
abort("no api_token") unless api_token

# Configure the api interface
toggl_api    = TogglV8::API.new(api_token)
user         = toggl_api.me(all=true)
workspaces   = toggl_api.my_workspaces(user)
ws_id        = default_workspace_id || workspaces.first['id']

# Since, January 1, 2016, to today, check if they're an entry, and create one if not.
Date.new(2016,01,01).upto(Date.today) do |dt|
  puts "Checking for #{dt.iso8601} weekday: #{dt.cwday}"

  # Check to see if there is an entry for current day.
  start_date = DateTime.new(dt.year, dt.month, dt.day, 0)
  end_date = DateTime.new(dt.year, dt.month, dt.day, 23)

  today_entries = toggl_api.get_time_entries({
    start_date: start_date.iso8601,
    end_date: end_date.iso8601
  })

  # Make entry unless is a saturday or sunday or entry exists.
  if today_entries.size < 1 && !dt.saturday? && !dt.sunday?
    sleep 2
    start_time = DateTime.new(dt.year, dt.month, dt.day, 8, 03, 00, "-0400")
    puts "making entry for #{start_time}"
    toggl_api.create_time_entry({
      'description' => "Hydra Work",
      'wid' => ws_id,
      'pid' => proj_id,
      'duration' => 26640,
      'start' => start_time.iso8601,
      'tags' => ['development'],
      'created_with' => "Otto T. Oggle"
    })
  else
    puts "Entry exits or is saturday or is sunday"
  end
end
