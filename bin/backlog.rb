#!/usr/bin ruby

require_relative '../lib/settings.rb'
require_relative '../lib/auto_togglr.rb'
require 'pp'

# Non-holiday non-weekend and has no entry already
def toggle_for_range(togglr, dates)
  dates.each do |date|
    if togglr.date_has_entry? date
      puts "#{date} has entry."
    elsif togglr.date_is_holiday? date
      puts "#{date} is umich holiday."
    elsif date.sunday? || date.saturday?
      puts "#{date} is a weekend."
    else
      puts "#{date} creating entry."
      #togglr.create_entry current_day 
    end
    sleep(1)
  end
end

puts 'Start Back toggling'

Settings.profiles.each do |profile|
  puts "Backfill for #{profile['uniqname']}"
  togglr = AutoTogglr.new profile
  dates = Date.new(2016,03,01)..Date.today
  toggle_for_range(togglr, dates)
end

puts "Done with back toggling."
