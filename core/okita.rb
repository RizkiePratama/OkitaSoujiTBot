require './core/helper/http'
require './module/anilist.rb'
require './module/instawalker.rb'
require './module/rexter/rexter.rb'

require_relative 'inline'
require_relative 'message'

module TBot
  class Okita
    attr_accessor :payload

    def initialize(payload)
      @payload = payload
    end

    def do_something
      # FETCH REQUEST
      # Is it Message or Inline?
      if payload.key?('inline_query')
        inline = TBot::Inline.new(@payload['inline_query'])

        # If Requesting Instagram Module from Inline Query
        if inline.request['query'].match?(/instagram/)
          inline.answers = TBotModule::InstaWalker::getFeed(inline.request['query'].split[1..-1].join(' '))
          inline.send_response 
        end

        # Perform Anime Query
        if inline.request['query'].match?(/anime/)
          inline.answers = TBotModule::Anilist::do_anime(inline.request['query'].split[1..-1].join(' '))
          inline.send_response
        end

        # Perform Anime Query
        if inline.request['query'].match?(/manga/)
          inline.answers = TBotModule::Anilist::do_manga(inline.request['query'].split[1..-1].join(' '))
          inline.send_response
        end

        # Perform Anime Query
        if inline.request['query'].match?(/character/)
          inline.answers = TBotModule::Anilist::do_character(inline.request['query'].split[1..-1].join(' '))
          inline.send_response
        end

        # Perform Anime Query
        if inline.request['query'].match?(/rexter/)
          query = inline.request['query'].split("\n")
          inline.answers = TBotModule::Rexter::build_and_run(query[0].split(" ")[1], query[1..-1].join("\n"))
          inline.send_response
        end

      end
    end
  end
end
