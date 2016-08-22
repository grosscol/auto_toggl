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
  def daily( user=nil )
    exit_msg("Uniquename required.") unless user 

    profile = profile_for user
    exit_msg("No matching profile.") if profile.empty?

    puts "Making daily entry for #{user}"
    make_daily_entry_for profile
  end

  desc "list", "List available user profiles." 
  def list
    Settings.profiles.each{ |profile| puts "user: #{profile['uniqname']} task: #{profile['description']}" }
  end

  desc "backfill USER", "Backfill to 2016-01-01 for user."
  def backfill( user=nil )
    exit_msg("Uniquename required.") unless user 

    profile = profile_for user
    puts "Backfill for #{profile['uniqname']}"

    togglr = AutoTogglr.new profile
    dates = Date.new(2016,03,01)..Date.today
    toggle_for_dates(togglr, dates)
  end

  private

  def exit_msg( msg )
    puts "#{msg}\n"
    exit 1
  end

  def profile_for(uniqname)
    Settings.profiles.select{ |p| p['uniqname'] == uniqname }.first
  end

  def toggle_for_dates(togglr, dates)
    dates.each do |date|
      if togglr.date_has_entry? date
        puts "#{date} already has entry."
      elsif date_in_holiday_list? date
        puts "#{date} is umich holiday."
      elsif date.sunday? || date.saturday?
        puts "#{date} is a weekend."
      else
        puts "#{date} creating entry."
        togglr.create_entry date 
      end
    end
  end

  def date_in_holiday_list?(date)
    Settings.holidays.include? date
  end

  def fill_all_profiles( start="2016-01-01" )
    Settings.profiles.each do |profile|
      puts "Backfill for #{profile['uniqname']}"
      togglr = AutoTogglr.new profile
      # TODO accept date string
      dates = Date.new(2016,03,01)..Date.today
      toggle_for_dates(togglr, dates)
    end
  end

  def make_daily_entry_for(profile, date = Date.today)
    togglr = AutoTogglr.new profile
    if togglr.date_has_entry?
      puts "Today has an entry for #{profile['uniqname']}. Skipping." 
    else
      puts "Creating entry for #{profile['uniqname']}"
      togglr.create_entry 
    end
  end

end

AutoToggleCli.start(ARGV)
