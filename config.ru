# APP SETTINGS
require 'settingslogic'
class Config < Settingslogic
  source "#{File.dirname(__FILE__)}/config/tbot.yml"
  namespace "development"
end

# TBOT CORE
core_dir =  File.join(File.dirname(__FILE__), 'core')
require File.join(core_dir, 'webhook')

run TBot::Webhook.new
