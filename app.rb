require 'sinatra/base'
require 'sinatra/activerecord'
require 'dotenv/load'
require 'haml'
require 'govuk_pay_api_client'
require 'securerandom'
require 'pry'
require 'byebug'
require 'excon'
require 'sinatra/asset_pipeline'

Dir['./models/*.rb'].each { |file| require file }

class Foxhound < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :database_file, 'config/database.yml'

  set :assets_paths, %w(assets/javascripts assets/stylesheets)
  register Sinatra::AssetPipeline

  get '/' do
    @pcn = PenaltyChargeNotice.new
    haml :penalty_charge_notice
  end

  post '/penalty-charge-notice' do
    @pcn = create_penalty_charge_notice(params)
    redirect url("/penalty-charge-notice/#{@pcn.payment.govpay_reference}") if @pcn.valid?
    haml :penalty_charge_notice
  end

  get '/penalty-charge-notice/:reference' do
    @payment = Payment.find_by!(govpay_reference: params[:reference])
    @pcn = PenaltyChargeNotice.find_by(payment_id: @payment.id)
    @payment.update_govpay_status
    haml :payment
  end

  post '/penalty-charge-notice/:reference/pay' do
    @payment = Payment.find_by!(govpay_reference: params[:reference])
    @payment.create_govpay_payment(return_url: url("/penalty-charge-notice/#{@payment.govpay_reference}"))
    redirect @payment.govpay_url
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
    Payment.create(
      govpay_reference: SecureRandom.hex(4),
      description: description,
      amount: amount,
      status: :pending
    )
  end
end

class String
  def blank?
    empty? || self == ''
  end
end
