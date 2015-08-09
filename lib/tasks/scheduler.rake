desc "This task is called by the Heroku scheduler add-on"
task :activate_ticket => :environment do
  puts "Activating Ticket..."
  CurrentTicket.claim
  puts "done at #{Time.now}."
end

# task :send_reminders => :environment do
#   User.send_reminders
# end