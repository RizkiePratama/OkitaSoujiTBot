require './core/helper/http/'

module TBot
  class Inline
    attr_accessor :request, :answers

    def initialize(request)
      @request = request
    end

    def send_response
      TBot::Helper::HTTP::post(
        "https://api.telegram.org/bot#{Config.token}/answerInlineQuery",
        "application/json",
        {
          "inline_query_id" => @request['id'],
          "results" => @answers,
          "is_personal" => true
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
      send_response
    end

    def send_unauthorized_response
      @answers = [{
        "type" => "article",
        "id" => 0,
        "title" => "I Don't Admit You As My Master!",
        "description" => "Who Are You? You did'nt have rights to use me!",
        "input_message_content" => { "message_text" => "As i said earlier, I Don't admit you as my master!", "parse_mode" => "html"},
      }]
      send_response
    end
  end
end
