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
	        sendResponse(webhook_request['message']['chat']['id'], webhook_request['message'].to_json)
	    else
	        "Invalid Request!"
	    end
	end

	def sendResponse(target_chat, message)
	    uri = URI.parse(Config.api_url + 'sendMessage')
	    headers = {"Content-Type" => "application/json"}
            http = Net::HTTP.new(uri.host, uri.port)
	    result = http.post(uri.path, message, headers)
	end
    end
end
