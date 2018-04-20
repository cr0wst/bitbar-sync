#!/usr/bin/env ruby

require 'uri'

# brew install terminal-notifier to get notifications
#
# Define the following variables:
SCREENSHOT_DIRECTORY = '/Users/dummy/Screenshots/'
LINK_PREFIX = 'https://share.example.com/'

# Add files here separated by spaces.
IGNORED_FILES = %w(. .. .DS_Store)

# Setup an .ssh/config for this user.
RSYNC_USER = 'deployer'
RSYNC_SERVER = 'deploy.example.com'
RSYNC_FOLDER = '/var/www/share.example.com/public_html'

# Copy this script into your BitBar plugin directory and chmod +x it.

# Do not edit below
begin
  def list_files
    puts 'Share'
    puts '---'
    puts "Capture Screenshot|bash=#{$0} param1=capture terminal=false"
    puts "Sync Directory|bash=#{$0} param1=sync terminal=false"
    puts '---'
    Dir.foreach SCREENSHOT_DIRECTORY do |file|
      next if IGNORED_FILES.include? file
      puts file
      puts '-- Go|href=' + build_link_string(file)
      puts "-- Copy Link|bash=#{$0} param1=copy param2=#{build_link_string(file)} terminal=false"
    end
  end

  def capture_screenshot
    time = Time.new;
    timestamp = time.strftime("%Y-%m-%d at %-H.%M.%S %p")
    file_name = 'Screen Shot ' + timestamp + '.png'
    file_path = SCREENSHOT_DIRECTORY + file_name
    %x(screencapture -i "#{file_path}")
    url = build_link_string(file_name)
    copy_url url
    %x(terminal-notifier -message "URL copied to clipboard" -title "Screenshot Uploaded" -appIcon "#{url}" -contentImage "#{url}")
    sync_directory
  end

  def copy_url url
    %x(echo #{url} | tr -d '\n' | pbcopy)
  end

  def build_link_string file
    LINK_PREFIX + URI::encode(file)
  end

  def sync_directory
    %x(rsync -a --delete --exclude index.html #{SCREENSHOT_DIRECTORY} #{RSYNC_USER}@#{RSYNC_SERVER}:#{RSYNC_FOLDER})
  end

  case ARGV[0]
  when 'copy'
    copy_url ARGV[1]
  when 'capture'
    capture_screenshot
  when 'sync'
    sync_directory
    list_files
  else
    list_files
  end
end