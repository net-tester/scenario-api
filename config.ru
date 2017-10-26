root = ::File.dirname(__FILE__)
require ::File.join(root, 'server')

configure do
  disable :protection
end

run Sinatra::Application
