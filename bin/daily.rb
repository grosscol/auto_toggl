#!/usr/bin ruby

require_relative '../lib/settings.rb'
require_relative '../lib/auto_togglr.rb'
require 'pp'

puts "Start entries for #{Date.today}"
profiles = Settings.profiles

profiles.each do |p|
  togglr = AutoTogglr.new p
  if togglr.date_has_entry?
    puts "Today has an entry for #{p['uniqname']}. Skipping." 
  else
    puts "Creating entry for #{p['uniqname']}"
    togglr.create_entry 
  end
  sleep(2)
end

puts "done"
