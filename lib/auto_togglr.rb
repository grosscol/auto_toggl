require 'togglv8'
require 'date'
require 'pry'

class AutoTogglr

  # API attributes
  attr :toggl_api, :user, :workspace 

  # Entry attributes
  attr :description, :project_id, :start, :duration, :tag, :now

  # initialize with a profile
  def initialize(profile)
    # Have token or die
    abort("no api_token") unless profile['api_token']
    configure profile
  end

  def configure(pf)
    @toggl_api  = ::TogglV8::API.new(pf['api_token'])
    @now = DateTime.now
    @user        = @toggl_api.me(all=true)
    @workspace   = pf['workspace_id']
    @project     = pf['project_id']
    @description = pf['description']
    @start_time  = DateTime.new(@now.year, @now.month, @now.day,
                               pf['start']['hour'],
                               pf['start']['minute'],
                               pf['start']['second'],
                               "-0400")
    @duration = pf['duration']
    @tag = pf['tag']
  end

  def workspaces
    workspaces = @toggl_api.my_workspaces(@user)
  end

  def projects(workspace_id=@workspace)
    projects = @toggl_api.projects workspace_id
  end

  def today_has_entry?
    start_date = DateTime.new(@now.year, @now.month, @now.day, 0)
    end_date   = DateTime.new(@now.year, @now.month, @now.day, 23)
    today_entries = @toggl_api.get_time_entries({
      start_date: start_date.iso8601,
      end_date: end_date.iso8601
    })
    today_entries.size > 0
  end

  def create_todays_entry
    start_time = DateTime.new(@now.year, @now.month, @now.day, 8, 03, 00, "-0400")

    @toggl_api.create_time_entry({
      'description' => @description,
      'wid' => @workspace,
      'pid' => @project,
      'duration' => @duration,
      'start' => start_time.iso8601,
      'tags' => [@tag],
      'created_with' => "Otto T. Oggle"
    })
  end
end
