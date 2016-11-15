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

ActiveRecord::Schema.define(version: 20161115114417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachinary_files", force: :cascade do |t|
    t.string   "attachinariable_type"
    t.integer  "attachinariable_id"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree
  end

  create_table "deals", force: :cascade do |t|
    t.integer  "offer_id"
    t.text     "request"
    t.datetime "deadline"
    t.float    "price"
    t.text     "proposition"
    t.text     "client_review"
    t.text     "advisor_review"
    t.integer  "client_rating"
    t.integer  "advisor_rating"
    t.datetime "proposition_at"
    t.datetime "accepted_at"
    t.datetime "closed_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "client_id"
    t.index ["offer_id"], name: "index_deals_on_offer_id", using: :btree
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mean_of_communications", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offer_languages", force: :cascade do |t|
    t.integer  "language_id"
    t.integer  "offer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["language_id"], name: "index_offer_languages_on_language_id", using: :btree
    t.index ["offer_id"], name: "index_offer_languages_on_offer_id", using: :btree
  end

  create_table "offer_mean_of_communications", force: :cascade do |t|
    t.integer  "mean_of_communication_id"
    t.integer  "offer_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["mean_of_communication_id"], name: "index_offer_mean_of_communications_on_mean_of_communication_id", using: :btree
    t.index ["offer_id"], name: "index_offer_mean_of_communications_on_offer_id", using: :btree
  end

  create_table "offers", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "advisor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "phone_number"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.text     "bio"
    t.date     "birth_date"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "deals", "offers"
  add_foreign_key "deals", "users", column: "client_id"
  add_foreign_key "offer_languages", "languages"
  add_foreign_key "offer_languages", "offers"
  add_foreign_key "offer_mean_of_communications", "mean_of_communications"
  add_foreign_key "offer_mean_of_communications", "offers"
  add_foreign_key "offers", "users", column: "advisor_id"
end
