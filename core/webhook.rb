require 'sinatra/base'

module TBot
    class Webhook < Sinatra::Base

	# WEBHOOK ENTRY POINT
        get '/' do
	    'Oops!, Ilegal Use!'
	end

	post '/' do
	    'Processing Incoming Request!'
	end

	def sendResponse()
	end
    end
end
