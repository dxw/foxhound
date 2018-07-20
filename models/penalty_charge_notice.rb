class PenaltyChargeNotice < ActiveRecord::Base
  after_initialize :prefill_data

  validates_presence_of :pcn_number
  validates_presence_of :vehicle_registration_mark

  belongs_to :payment

  CHARGES = {
    parking_meter_expired: 60_00,
    no_parking_permit: 110_00,
    driving_in_bus_lane: 130_00
  }.freeze

  def charge_amount
    return CHARGES[charge_type.to_sym] / 2 if discounted?
    CHARGES[charge_type.to_sym]
  end

  def discounted?
    issued_at > 14.days.ago
  end

  def description
    charge_type.humanize + (discounted? ? ' (early payment discount)' : '')
  end

  private

  def prefill_data
    self.charge_type ||= CHARGES.keys.sample
    self.issued_at ||= random_previous_date
  end

  def random_previous_date
    Time.now - (0..30).to_a.sample.days
  end
end
