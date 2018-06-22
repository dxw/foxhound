require 'sinatra'
require 'haml'
require 'govuk_pay_api_client'
require 'securerandom'
require 'pry'
require 'byebug'
require 'excon'

get '/' do
  @next_url = create_payment
  haml :pay_now
end
get '/success/:reference' do
  @payment_reference = params[:reference]
  haml :success
end

def base_url
  'https://dxw-foxhound.herokuapp.com'
  # "https://#{request.env['HTTP_HOST']}"
end

def create_payment
  reference = SecureRandom.hex(4)
  GovukPayApiClient::CreatePayment.call(
    OpenStruct.new(
      description: 'Scarfolk council temporary event notice',
      govpay_reference: reference,
      amount: 2100,
    ),
    "#{base_url}/success/#{reference}",
  ).next_url
end

class String
  def blank?
    self.empty? || self == ""
  end
end
