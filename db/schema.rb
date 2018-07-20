# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_20_142203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "payments", force: :cascade do |t|
    t.string "description"
    t.string "govpay_reference"
    t.integer "amount"
    t.string "status"
    t.string "govpay_url"
    t.string "govpay_payment_id"
  end

  create_table "penalty_charge_notices", force: :cascade do |t|
    t.string "pcn_number"
    t.string "vehicle_registration_mark"
    t.bigint "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "charge_type"
    t.date "issued_at"
    t.index ["payment_id"], name: "index_penalty_charge_notices_on_payment_id"
  end

end
