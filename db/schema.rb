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

ActiveRecord::Schema.define(version: 20171121102208) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "additional_owners", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "birth_date"
    t.string   "address"
    t.string   "zip_code"
    t.string   "city"
    t.string   "state"
    t.string   "country_code"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_additional_owners_on_user_id", using: :btree
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
    t.datetime "opened_at"
    t.datetime "closed_at"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "client_id"
    t.integer  "amount_cents"
    t.json     "payment"
    t.integer  "status",                default: 0
    t.datetime "client_review_at"
    t.datetime "advisor_review_at"
    t.datetime "proposition_deadline"
    t.integer  "advisor_rating"
    t.integer  "client_rating"
    t.boolean  "messages_disabled",     default: false, null: false
    t.integer  "who_reviews",           default: 0
    t.integer  "payment_state",         default: 0
    t.integer  "client_notifications",  default: 0
    t.integer  "advisor_notifications", default: 0
    t.string   "room_name"
    t.integer  "fees_cents"
    t.string   "title"
    t.string   "currency_code"
    t.json     "payout"
    t.integer  "duration",              default: 30
    t.index ["offer_id"], name: "index_deals_on_offer_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
  end

  create_table "means", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "picto"
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
    t.integer  "pricing",     default: 1
    t.string   "slug"
    t.index ["slug"], name: "index_offers_on_slug", unique: true, using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
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
    t.string   "country_code"
    t.boolean  "admin",                  default: false, null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "locale"
    t.string   "stripe_customer_id"
    t.string   "stripe_account_id"
    t.string   "currency_code",          default: "EUR"
    t.string   "state"
    t.integer  "pricing",                default: 0
    t.integer  "legal_type",             default: 0
    t.string   "business_name"
    t.string   "business_tax_id"
    t.string   "personal_address"
    t.string   "personal_city"
    t.string   "personal_zip_code"
    t.string   "personal_state"
    t.string   "bank_name"
    t.string   "bank_last4"
    t.integer  "bank_status",            default: 0
    t.string   "identity_document_name"
    t.string   "disabled_reason"
    t.string   "verification_status"
    t.boolean  "verified",               default: false, null: false
    t.integer  "status",                 default: 0
    t.string   "slug"
    t.integer  "unread_messages",        default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.string   "votable_type"
    t.integer  "votable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  end

  add_foreign_key "additional_owners", "users"
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
end
