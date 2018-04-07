require './core/helper/http/'

module TBot
  class Message
    attr_accessor :request, :answers

    def initialize(request)
      @request = request
    end

    def send_response(message)
      TBot::Helper::HTTP::post(
        "https://api.telegram.org/bot#{Config.token}/sendMessage",
        "application/json",
        {
          "chat_id" => @request['chat']['id'],
          "text" => message,
          "pars_mode" => "html"
        }
      )
    end
  end
end
