class AddTypeToPenaltyChargeNotices < ActiveRecord::Migration[5.2]
  def change
    add_column :penalty_charge_notices, :charge_type, :string
  end
end
