require 'sinatra'
require 'haml'
require 'pry'
require 'byebug'

get '/' do
  haml :pay_now
end
get '/success' do
  haml :success
end
