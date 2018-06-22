require 'sinatra'
require 'haml'

get '/' do
  haml :pay_now
end
get '/success' do
  haml :success
end
