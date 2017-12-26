require 'sinatra/base'
require 'json'
require 'fileutils'

module TBot
    class Webhook < Sinatra::Base

	# WEBHOOK ENTRY POINT
        get '/' do
	    'Oops!, Ilegal Use!'
	end

	post '/' do
	    tmp_dir = File.join(File.dirname(File.dirname(__FILE__)), 'tmp')
	    unless File.directory?(tmp_dir)
		'No TMP, Making One....'
	        FileUtils.mkdir_p(tmp_dir)
	    end
            values = JSON.parse(request.env["rack.input"].read)
	    File.open(File.join(tmp_dir, 'webhook_input.log'), 'w') { |log| log.write(values) }
	    'Done..'
	end

	def sendResponse()
	end
    end
end
