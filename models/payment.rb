require 'govuk_pay_api_client'

class Payment < ActiveRecord::Base
  validates_presence_of :description
  validates_presence_of :govpay_reference
  validates_presence_of :amount

  def successful?
    status == 'success'
  end

  def pending?
    status == 'pending'
  end

  def failed?
    status == 'failed'
  end

  def update_govpay_status
    return if pending?
    GovukPayApiClient::GetStatus.call(self).tap do |govpay_response|
      update(status: govpay_response.status)
    end
  end

  def create_govpay_payment(return_url:)
    return unless pending?
    GovukPayApiClient::CreatePayment.call(
      self,
      return_url
    ).tap do |govpay_response|
      update(
        govpay_payment_id: govpay_response.payment_id,
        govpay_url: govpay_response.next_url,
        status: :created
      )
    end
  end
end
