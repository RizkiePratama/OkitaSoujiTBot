require 'sinatra/base'
require 'xmlsimple'
require './core/helper/http'
require './module/anilist.rb'
require './module/instawalker.rb'

require_relative 'inline'
require_relative 'message'

module TBot
  class Webhook < Sinatra::Base

    # WEBHOOK ENTRY POINT
    get '/' do
      'Oops!, Ilegal Use!'
    end

    post '/' do
      payload = JSON.parse(request.body.read)

      # FETCH REQUEST
      # Is it Message or Inline?
      if payload.key?('inline_query')

        # If Requesting Instagram Module from Inline Query
        if inline.request['query'].include?("instagram")
          inline.answers = TBotModule::InstaWalker::getFeed(inline.request['query'].gsub(/\s+/m, ' ').strip.split(" ")[1])
          if inline.answers == false
            inline.send_empty_response
          else
            inline.send_response
          end
          return true
        end

        # DEFAULT, Perform Anime Query
        inline.answers = TBotModule::Anilist::search('anime',inline.request['query'])
        if inline.answers == false
          inline.send_empty_response
        else
          inline.send_response
        end
      elsif payload.key?('message')
        if payload['message']['from']['id'] != master_id then return false end
        message = TBot::Message.new(payload['message'])
      else
        puts "hmm,It's Not Inline or a Message, i don't know how to process this Yet!"
        puts "Inspect => #{payload.inspect}"
      end
    end
  end
end
