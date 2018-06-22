require 'sinatra'
require 'haml'
require 'govuk_pay_api_client'
require 'pry'
require 'byebug'

get '/' do
  haml :pay_now
end
get '/success' do
  haml :success
end
