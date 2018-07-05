class Payment < ActiveRecord::Base
  validates_presence_of :description
  validates_presence_of :govpay_reference
  validates_presence_of :amount

  def successful?
    status == 'success'
  end
end
