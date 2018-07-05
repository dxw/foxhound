require 'sinatra/base'
require 'haml'
require 'govuk_pay_api_client'
require 'securerandom'
require 'pry'
require 'byebug'
require 'excon'
require 'sprockets'
require 'uglifier'
require 'sass'

class Foxhound < Sinatra::Base
  # initialize new sprockets environment
  set :environment, Sprockets::Environment.new

  # append assets paths
  environment.append_path 'assets/stylesheets'
  environment.append_path 'assets/javascripts'

  # compress assets
  environment.js_compressor  = :uglify
  environment.css_compressor = :scss

  # get assets
  get '/assets/*' do
    env['PATH_INFO'].sub!('/assets', '')
    settings.environment.call(env)
  end

  get '/' do
    @next_url = create_payment
    haml :pay_now
  end
  get '/success/:reference' do
    @payment_reference = params[:reference]
    haml :success
  end

  def base_url
    "http://#{request.env['HTTP_HOST']}"
  end

  def create_payment
    reference = SecureRandom.hex(4)
    GovukPayApiClient::CreatePayment.call(
      OpenStruct.new(
        description: 'Scarfolk council temporary event notice',
        govpay_reference: reference,
        amount: 2100
      ),
      "#{base_url}/success/#{reference}"
    ).next_url
  end
end

class String
  def blank?
    empty? || self == ''
  end
end
