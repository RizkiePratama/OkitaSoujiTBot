
require 'ostruct'

module TBot
    Config = OpenStruct.new

    #
    Config.api_url = 'https://api.telegram.org/bot' + ENV['BOT_TOKEN'] + '/' 
end
