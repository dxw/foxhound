require 'sinatra'
require 'haml'

get '/' do
  haml :pay_now
end
