require 'sinatra/base'
require 'sinatra/activerecord'
require 'dotenv/load'
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
    @pcn = PenaltyChargeNotice.new
    haml :penalty_charge_notice
  end

  post '/penalty-charge-notice' do
    @pcn = create_penalty_charge_notice(params)
    redirect pcn.payment.govpay_url if @pcn.valid?
    haml :penalty_charge_notice
  end

  get '/payment/:reference' do
    @payment = update_payment_status(params[:reference])
    haml :payment
  end

  def create_penalty_charge_notice(params)
    PenaltyChargeNotice.new(
      pcn_number: params[:pcn_number],
      vehicle_registration_mark: params[:registration_mark]
    ).tap do |penalty_charge_notice|
      if penalty_charge_notice.valid?
        penalty_charge_notice.payment = create_payment(description: 'Scarfolk Council PCN', amount: 4500)
        penalty_charge_notice.save
      end
    end
  end

  def create_payment(description:, amount:)
    payment = Payment.create(
      govpay_reference: SecureRandom.hex(4),
      description: description,
      amount: amount
    )
    GovukPayApiClient::CreatePayment.call(
      payment,
      url("/payment/#{payment.govpay_reference}")
    ).tap do |govpay_response|
      payment.update(
        govpay_payment_id: govpay_response.payment_id,
        govpay_url: govpay_response.next_url,
        status: :created
      )
    end
    payment
  end

  def update_payment_status(reference)
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
