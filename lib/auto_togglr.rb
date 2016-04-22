require 'togglv8'
require 'date'
require 'pry'

class AutoTogglr

  # API attributes
  attr :toggl_api, :user, :workspace 

  # Entry attributes
  attr :description, :project_id, :start, :duration, :tag, :now

  # initialize with a profile
  def initialize(pf)
    puts "Initialize for #{pf['uniqname']}"
    # Have token or die
    abort("no api_token") unless pf['api_token']

    self.now = DateTime.now
    self.toggle_api  = TogglV8::API.new(pf['api_token'])
    self.user        = toggl_api.me(all=true)
    self.workspace   = pf['workspace_id']
    self.project     = pf['project_id']
    self.description = pf['description']
    self.start_time  = DateTime.new(now.year, now.month, now.day,
                               pf['start']['hour'],
                               pf['start']['minute'],
                               pf['start']['second'],
                               "-0400")
    self.duration = pf['duration']
    self.tag = pf['tag']
  end

  def information
    workspaces = toggl_api.my_workspaces(user)
  end

  def today_has_entry?
    start_date = DateTime.new(now.year, now.month, now.day, 0)
    end_date   = DateTime.new(now.year, now.month, now.day, 23)
    today_entries = toggl_api.get_time_entries({
      start_date: start_date.iso8601,
      end_date: end_date.iso8601
    })

    today_entries.size > 0
  end

  def create_todays_entry
    start_time = DateTime.new(now.year, now.month, now.day, 8, 03, 00, "-0400")

    toggl_api.create_time_entry({
      'description' => "Hydra Work",
      'wid' => ws_id,
      'pid' => proj_id,
      'duration' => 26640,
      'start' => start_time.iso8601,
      'tags' => ['development'],
      'created_with' => "Otto T. Oggle"
    })
  end
end
