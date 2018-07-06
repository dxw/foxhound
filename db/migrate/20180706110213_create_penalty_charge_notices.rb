class CreatePenaltyChargeNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :penalty_charge_notices do |t|
      t.string :pcn_number
      t.string :vehicle_registration_mark
      t.references :payment, index: true
      t.timestamps
    end
  end
end
