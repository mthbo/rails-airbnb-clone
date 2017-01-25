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

ActiveRecord::Schema.define(version: 20170124154204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

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

  create_table "deal_languages", force: :cascade do |t|
    t.integer  "deal_id"
    t.integer  "language_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["deal_id"], name: "index_deal_languages_on_deal_id", using: :btree
    t.index ["language_id"], name: "index_deal_languages_on_language_id", using: :btree
  end

  create_table "deal_means", force: :cascade do |t|
    t.integer  "deal_id"
    t.integer  "mean_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deal_id"], name: "index_deal_means_on_deal_id", using: :btree
    t.index ["mean_id"], name: "index_deal_means_on_mean_id", using: :btree
  end

  create_table "deals", force: :cascade do |t|
    t.integer  "offer_id"
    t.text     "request"
    t.datetime "deadline"
    t.text     "proposition"
    t.text     "client_review"
    t.text     "advisor_review"
    t.datetime "proposition_at"
    t.datetime "open_at"
    t.datetime "closed_at"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "client_id"
    t.integer  "amount_cents"
    t.json     "payment"
    t.integer  "status",               default: 0
    t.datetime "client_review_at"
    t.datetime "advisor_review_at"
    t.datetime "proposition_deadline"
    t.integer  "advisor_rating"
    t.integer  "client_rating"
    t.boolean  "messages_disabled",    default: false, null: false
    t.integer  "who_reviews",          default: 0
    t.integer  "payment_state",        default: 0
    t.index ["offer_id"], name: "index_deals_on_offer_id", using: :btree
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "means", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.text     "content"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "target",     default: 0
    t.index ["deal_id"], name: "index_messages_on_deal_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "objectives", force: :cascade do |t|
    t.text     "description"
    t.integer  "rating"
    t.integer  "deal_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["deal_id"], name: "index_objectives_on_deal_id", using: :btree
  end

  create_table "offer_languages", force: :cascade do |t|
    t.integer  "language_id"
    t.integer  "offer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["language_id"], name: "index_offer_languages_on_language_id", using: :btree
    t.index ["offer_id"], name: "index_offer_languages_on_offer_id", using: :btree
  end

  create_table "offer_means", force: :cascade do |t|
    t.integer  "mean_id"
    t.integer  "offer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mean_id"], name: "index_offer_means_on_mean_id", using: :btree
    t.index ["offer_id"], name: "index_offer_means_on_offer_id", using: :btree
  end

  create_table "offers", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "advisor_id"
    t.integer  "status",      default: 0
    t.integer  "pricing",     default: 0
  end

  create_table "pinned_offers", force: :cascade do |t|
    t.integer  "offer_id"
    t.integer  "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_pinned_offers_on_client_id", using: :btree
    t.index ["offer_id"], name: "index_pinned_offers_on_offer_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "phone_number"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.text     "bio"
    t.date     "birth_date"
    t.string   "provider"
    t.string   "uid"
    t.string   "facebook_picture_url"
    t.string   "token"
    t.datetime "token_expiry"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "zip_code"
    t.string   "city"
    t.string   "country"
    t.boolean  "admin",                  default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "deal_languages", "deals"
  add_foreign_key "deal_languages", "languages"
  add_foreign_key "deal_means", "deals"
  add_foreign_key "deal_means", "means"
  add_foreign_key "deals", "offers"
  add_foreign_key "deals", "users", column: "client_id"
  add_foreign_key "messages", "deals"
  add_foreign_key "messages", "users"
  add_foreign_key "objectives", "deals"
  add_foreign_key "offer_languages", "languages"
  add_foreign_key "offer_languages", "offers"
  add_foreign_key "offer_means", "means"
  add_foreign_key "offer_means", "offers"
  add_foreign_key "offers", "users", column: "advisor_id"
  add_foreign_key "pinned_offers", "offers"
  add_foreign_key "pinned_offers", "users", column: "client_id"
end
