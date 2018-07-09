class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.string :description
      t.string :govpay_reference
      t.integer :amount
      t.string :status
      t.string :govpay_payment_id
    end
  end
end
