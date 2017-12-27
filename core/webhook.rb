require 'sinatra/base'
require 'net/http'
require 'json'
require 'uri'

module TBot
    class Webhook < Sinatra::Base

	# WEBHOOK ENTRY POINT
        get '/' do
	    'Oops!, Ilegal Use!'
	end

	post '/' do
	    webhook_request = JSON.parse(request.env["rack.input"].read)
	    if webhook_request.has_key? 'message'
	        sendResponse(webhook_request['message']['chat']['id'], JSON.pretty_generate(webhook_request))
	    else
	        "Invalid Request!"
	    end
	end

	def sendResponse(target_chat, message)
	    if target_chat.nil? || message.nil?
	        puts "Empty Response Returned"
		return nil
	    end
	    uri = URI.parse(Config.api_url + 'sendMessage')
	    headers = {"Content-Type" => "application/json"}
            http = Net::HTTP.new(uri.host, uri.port)
	    response_json = {"chat_id": target_chat, "text": '```' + message + '```', "parse_mode": "markdown"}.to_json
	    result = http.post(uri.path, response_json, headers)

	    puts "DEBUG RESPONSE\n==============================="
	    puts result.header
	    puts result.body
	    puts "============================="
	    puts "GIVEN JSON RESPONSE:"
	    puts response_json
	    puts "============================="
	    puts "TARGET API: " + uri.to_s
	end
    end
end
