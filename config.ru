
core_dir =  File.join(File.dirname(__FILE__), 'core')

require File.join(File.dirname(__FILE__), 'config/tbot')
require File.join(core_dir, 'webhook')

run TBot::Webhook.new
