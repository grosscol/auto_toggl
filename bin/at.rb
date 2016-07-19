#!/usr/bin/ruby

require_relative '../lib/settings.rb'
require_relative '../lib/auto_togglr.rb'
require 'pp'
require 'thor'
require 'pry'

class AutoToggleCli < Thor
  desc "backfill START_DATE USER", "Backfill the dates for given user."
  def backfill( start="2016-01-01", user=nil )
    exit_msg("Uniquename required.") unless user 

    profile = profile_for user
    exit_msg("No matching profile.") if profile.empty?

    puts "Running backfill for #{user}"
  end

  desc "daily USER", "Make daily entry for user"
  def daily( user=nil)
    exit_msg("Uniquename required.") unless user 

    profile = profile_for user
    exit_msg("No matching profile.") if profile.empty?

    puts "Making daily entry for #{user}"
  end

  private

  def exit_msg( msg )
    puts "#{msg}\n"
    exit 1
  end

  def profile_for(uniqname)
    Settings.profiles.select{ |p| p['uniqname'] == uniqname }
  end

  def fill_all_profiles( start="2016-01-01" )
    Settings.profiles.each do |profile|
      puts "Backfill for #{profile['uniqname']}"
      togglr = AutoTogglr.new profile
      # TODO accept date string
      dates = Date.new(2016,03,01)..Date.today
      toggle_for_range(togglr, dates)
    end
  end

end

AutoToggleCli.start(ARGV)
