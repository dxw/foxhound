class AddIssuedAtToPenaltyChargeNotices < ActiveRecord::Migration[5.2]
  def change
    add_column :penalty_charge_notices, :issued_at, :date
  end
end
