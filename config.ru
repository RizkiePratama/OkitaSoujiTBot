# APP SETTINGS
require 'settingslogic'
class Config < Settingslogic
  source "#{File.dirname(__FILE__)}/config/tbot.yml"
  namespace "development"
end

# TBOT CORE
core_dir =  File.join(File.dirname(__FILE__), 'core')
require File.join(core_dir, 'okita')

# WEBHOOK ENTRY POINT
require 'sinatra/base'
class Webhook < Sinatra::Base
    get '/' do
      'Oops!, Ilegal Use!'
    end

    post '/' do
      okitabot = TBot::Okita.new(JSON.parse(request.body.read))
      okitabot.do_something
    end
end

run Webhook.new
