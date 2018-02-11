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

ActiveRecord::Schema.define(version: 20180206234720) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "aeroplanes", force: :cascade do |t|
    t.string "plate", limit: 6, default: "", null: false
    t.string "plane_type", limit: 6, default: "", null: false
    t.string "brand", limit: 20, default: "", null: false
    t.string "next_revision", limit: 10, default: "", null: false
    t.string "flying_time", limit: 10, default: "", null: false
    t.integer "state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "aeroplanes_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "aeroplane_id", null: false
    t.index ["aeroplane_id", "user_id"], name: "index_aeroplanes_users_on_aeroplane_id_and_user_id"
    t.index ["user_id", "aeroplane_id"], name: "index_aeroplanes_users_on_user_id_and_aeroplane_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "finish_time", null: false
    t.integer "user_id", null: false
    t.integer "aeroplane_id", null: false
    t.integer "instructor_id"
    t.string "flight_type", null: false
    t.text "route", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aeroplane_id"], name: "index_reservations_on_aeroplane_id"
    t.index ["instructor_id"], name: "index_reservations_on_instructor_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "rut", null: false
    t.integer "membership_number", null: false
    t.string "name", null: false
    t.string "last_name", null: false
    t.string "address", null: false
    t.integer "phone", null: false
    t.string "country", null: false
    t.datetime "birthdate", null: false
    t.string "license_type", null: false
    t.integer "license_number", null: false
    t.integer "user_role", null: false
    t.string "membership_type", null: false
    t.integer "membership_state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["rut"], name: "index_users_on_rut", unique: true
  end

end
