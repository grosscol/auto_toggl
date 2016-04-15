require 'togglv8'

# Read the config
cfg = YAML.load_file('../config/auto_toggl.yml')
api_token = cfg[:api_token]

# Have token or die
abort("no api_token") unless api_token

# Configure the api interface
toggl_api    = TogglV8::API.new(<API_TOKEN>)
user         = toggl_api.me(all=true)
workspaces   = toggl_api.my_workspaces(user)
workspace_id = workspaces.first['id']

workspaces.each{|w| puts w}

# toggl_api.create_time_entry({
#   'description' => "Workspace time entry",
#   'wid' => workspace_id,
#   'duration' => 1200,
#   'start' => "2015-08-18T01:13:40.000Z",
#   'created_with' => "My awesome Ruby application"
# })
