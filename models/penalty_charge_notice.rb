class PenaltyChargeNotice < ActiveRecord::Base
  validates_presence_of :pcn_number
  validates_presence_of :vehicle_registration_mark
end
