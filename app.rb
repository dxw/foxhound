require 'sinatra/base'
require 'sinatra/activerecord'
require 'haml'
require 'govuk_pay_api_client'
require 'securerandom'
require 'pry'
require 'byebug'
require 'excon'
require 'sprockets'
require 'uglifier'
require 'sass'

Dir['./models/*.rb'].each { |file| require file }

class Foxhound < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :database_file, 'config/database.yml'
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
    haml :pay_now
  end

  post '/' do
    payment = create_payment
    redirect payment.next_url
  end

  get '/payment/:reference' do
    @payment = update_payment(params[:reference])
    haml :payment
  end

  def create_payment
    payment = Payment.create(
      govpay_reference: SecureRandom.hex(4),
      description: 'Scarfolk Council PCN',
      amount: 4500
    )
    GovukPayApiClient::CreatePayment.call(
      payment,
      url("/payment/#{payment.govpay_reference}")
    ).tap do |govpay_response|
      payment.update(
        govpay_payment_id: govpay_response.payment_id,
        status: :created
      )
    end
  end

  def update_payment(reference)
    payment = Payment.find_by!(govpay_reference: reference)
    GovukPayApiClient::GetStatus.call(payment).tap do |govpay_response|
      payment.update(status: govpay_response.status)
    end
    payment
  end
end

class String
  def blank?
    empty? || self == ''
  end
end
