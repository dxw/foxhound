class PenaltyChargeNotice < ActiveRecord::Base
  after_initialize :set_charge_type

  validates_presence_of :pcn_number
  validates_presence_of :vehicle_registration_mark

  belongs_to :payment

  CHARGES = {
    parking_meter_expired: 60_00,
    no_parking_permit: 110_00,
    driving_in_bus_lane: 130_00
  }.freeze

  def charge_amount
    CHARGES[charge_type.to_sym]
  end

  private

  def set_charge_type
    self.charge_type = CHARGES.keys.sample
  end
end
