# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
set :environment, "development"
set :output, "log/cron.log"
env :SPOTIFY_CLIENT_ID, ENV["SPOTIFY_CLIENT_ID"]
env :SPOTIFY_CLIENT_SECRET, ENV["SPOTIFY_CLIENT_ID"]
env :CHARTMETRIC_REFRESH_TOKEN, ENV["SPOTIFY_CLIENT_ID"]
env :BROWSE_API_KEY, ENV["SPOTIFY_CLIENT_ID"]

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.day, at: "9:00 am" do
  runner "ChartmetricAllStreamsJob.perform_later"
end
