require './core/helper/http/'

module TBot
  class Inline
    attr_accessor :request, :answers

    def initialize(request)
      @request = request
    end

    def send_response
      if !answers || @answers.nil? || @answers.empty? 
        send_empty_response
        log
      end

      return TBot::Helper::HTTP::post(
        "https://api.telegram.org/bot#{Config.token}/answerInlineQuery",
        "application/json",
        {
          "inline_query_id" => @request['id'],
          "results" => @answers,
        }
      )
    end

    def send_empty_response
      @answers = [{
        "type" => "article",
        "id" => 0,
        "title" => "Opps! I Can't Find Anything :(",
        "description" => "Please try again with another keywords...",
        "input_message_content" => { "message_text" => "Nothing :(", "parse_mode" => "html"},
      }]
    end

    def log
      # LOG THIS
      open('AccessLog.txt', 'a') { |ss|
        ss << "Someone else trying to Command Me:\n"
        ss << "User ID: #{request['from']['id']}\n"
        ss << "Display Name: #{request['from']['first_name']} #{request['from']['last_name']}\n"
        ss << "Username: #{request['from']['username']}\n"
        ss << "Query: #{request['query']}\n"
        ss << "----------------------------------\n"
      }

      send_response
    end
  end
end
