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

ActiveRecord::Schema.define(version: 2019_02_11_134862) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.bigint "typecodeid"
    t.string "typecodegroup"
    t.string "typecode"
    t.string "definitionfrench"
    t.string "definition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.bigint "typecodeid"
    t.string "typecodegroup"
    t.string "typecode"
    t.string "definition"
    t.string "definition_french"
    t.string "definition_spanish"
    t.string "definition_chinese"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "preconisations", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.text "investment_strategy"
    t.text "current_strategy"
    t.bigint "share_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "preconisation_id"
    t.index ["preconisation_id"], name: "index_reviews_on_preconisation_id"
    t.index ["share_id"], name: "index_reviews_on_share_id"
  end

  create_table "share_catalogs", force: :cascade do |t|
    t.bigint "share_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status", default: false, null: false
    t.index ["company_id"], name: "index_share_catalogs_on_company_id"
    t.index ["share_id"], name: "index_share_catalogs_on_share_id"
  end

  create_table "shares", force: :cascade do |t|
    t.string "isin"
    t.string "secid"
    t.string "performanceid"
    t.string "fundid"
    t.string "securityname"
    t.string "companyname"
    t.string "fundname"
    t.string "legalstructure"
    t.string "shareclasslegalname"
    t.boolean "ucits"
    t.string "morningstarcategoryid"
    t.boolean "isbasecurrency"
    t.boolean "isprimaryshareclass"
    t.string "currencyspecificisin"
    t.string "currencyid"
    t.string "masterportfolioid"
    t.string "legalstructureid"
    t.boolean "fr_pea"
    t.datetime "portfoliodate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_companies", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_user_companies_on_company_id"
    t.index ["user_id"], name: "index_user_companies_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "reviews", "shares"
  add_foreign_key "share_catalogs", "companies"
  add_foreign_key "share_catalogs", "shares"
  add_foreign_key "user_companies", "companies"
  add_foreign_key "user_companies", "users"
end
