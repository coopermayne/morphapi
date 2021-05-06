# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_09_202255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "awards", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "overview"
    t.integer "hit"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "primary_id"
    t.integer "old_id"
    t.integer "index_image_id"
  end

  create_table "awards_projects", id: false, force: :cascade do |t|
    t.integer "award_id"
    t.integer "project_id"
    t.index ["award_id"], name: "index_awards_projects_on_award_id"
    t.index ["project_id"], name: "index_awards_projects_on_project_id"
  end

  create_table "bibliography_items", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "overview"
    t.integer "hit"
    t.string "author"
    t.string "article_name"
    t.string "book_title"
    t.string "subtitle"
    t.string "publication"
    t.string "publisher"
    t.string "date"
    t.date "pub_date"
    t.string "pages"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "primary_id"
    t.integer "old_id"
    t.integer "index_image_id"
    t.string "link"
  end

  create_table "bibliography_items_people", id: false, force: :cascade do |t|
    t.integer "bibliography_item_id", null: false
    t.integer "person_id", null: false
  end

  create_table "bibliography_items_projects", id: false, force: :cascade do |t|
    t.integer "bibliography_item_id"
    t.integer "project_id"
    t.index ["bibliography_item_id"], name: "index_bibliography_items_projects_on_bibliography_item_id"
    t.index ["project_id"], name: "index_bibliography_items_projects_on_project_id"
  end

  create_table "component_types", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "old_id"
  end

  create_table "components", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.integer "component_type_id"
    t.integer "old_id"
    t.string "title"
    t.boolean "is_visible", default: false
    t.index ["component_type_id"], name: "index_components_on_component_type_id"
    t.index ["project_id"], name: "index_components_on_project_id"
  end

  create_table "credits", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "old_id"
  end

  create_table "educations", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.index ["person_id"], name: "index_educations_on_person_id"
  end

  create_table "file_types", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "old_id"
  end

  create_table "journalists", id: :serial, force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "affiliation"
  end

  create_table "news_items", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "overview"
    t.integer "hit"
    t.string "place_name"
    t.string "street_address"
    t.string "country"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "news_type_id"
    t.integer "primary_id"
    t.boolean "in_news_box", default: false
    t.integer "old_id"
    t.integer "index_image_id"
    t.string "address"
    t.integer "rank"
    t.string "link"
    t.index ["news_type_id"], name: "index_news_items_on_news_type_id"
  end

  create_table "news_types", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "old_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "last_name"
    t.date "birthday"
    t.text "description"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_morphosis"
    t.boolean "is_employed"
    t.boolean "is_collaborator"
    t.boolean "is_consultant"
    t.date "start_date"
    t.date "end_date"
    t.string "website"
    t.integer "hit"
    t.string "location"
    t.integer "primary_id"
    t.integer "old_id"
    t.integer "index_image_id"
    t.boolean "is_leadership", default: false
    t.boolean "is_associate", default: false
  end

  create_table "positions", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank"
    t.integer "old_id"
  end

  create_table "project_types", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "rank"
    t.string "ancestry"
    t.integer "section_id"
    t.integer "old_id"
    t.index ["section_id"], name: "index_project_types_on_section_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "overview"
    t.text "description"
    t.text "program"
    t.string "client"
    t.integer "size"
    t.decimal "site_area"
    t.decimal "lat"
    t.decimal "lon"
    t.string "street_address"
    t.integer "zip"
    t.date "design_sdate"
    t.date "design_edate"
    t.date "constr_sdate"
    t.date "constr_edate"
    t.date "open_date"
    t.date "close_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "section_id"
    t.integer "height"
    t.integer "hit"
    t.string "city"
    t.string "state"
    t.string "country"
    t.integer "primary_id"
    t.integer "old_id"
    t.integer "index_image_id"
    t.string "address"
    t.text "sustainability"
    t.index ["section_id"], name: "index_projects_on_section_id"
  end

  create_table "projects_project_types", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.integer "project_type_id"
    t.index ["project_id"], name: "index_projects_project_types_on_project_id"
    t.index ["project_type_id"], name: "index_projects_project_types_on_project_type_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.integer "project_id"
    t.integer "position_id"
    t.integer "old_id"
    t.integer "rank", default: 99999999
    t.index ["person_id"], name: "index_roles_on_person_id"
    t.index ["position_id"], name: "index_roles_on_position_id"
    t.index ["project_id"], name: "index_roles_on_project_id"
  end

  create_table "search_results", id: :serial, force: :cascade do |t|
    t.text "content"
    t.string "title"
    t.integer "searchable_id"
    t.string "searchable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 0
    t.string "thumb"
    t.string "description"
    t.string "uid"
    t.string "section"
    t.string "sorting_type"
    t.index ["searchable_type", "searchable_id"], name: "index_search_results_on_searchable_type_and_searchable_id"
  end

  create_table "sections", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank"
    t.text "content"
    t.integer "old_id"
    t.text "about"
    t.text "contact"
    t.text "employment"
    t.text "media"
  end

  create_table "slides", id: :serial, force: :cascade do |t|
    t.integer "rank"
    t.boolean "visible"
    t.boolean "is_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "section_id"
    t.integer "image_upload_id"
    t.integer "vida_upload_id"
    t.integer "vidb_upload_id"
    t.integer "gif_upload_id"
    t.integer "project_id"
    t.string "title"
    t.index ["project_id"], name: "index_slides_on_project_id"
    t.index ["section_id"], name: "index_slides_on_section_id"
  end

  create_table "uploads", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "copyright"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.integer "file_type_id"
    t.integer "credit_id"
    t.integer "uploadable_id"
    t.string "uploadable_type"
    t.boolean "in_gallery"
    t.boolean "is_featured"
    t.integer "old_id"
    t.index ["credit_id"], name: "index_uploads_on_credit_id"
    t.index ["file_type_id"], name: "index_uploads_on_file_type_id"
    t.index ["uploadable_type", "uploadable_id"], name: "index_uploads_on_uploadable_type_and_uploadable_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "educations", "people"
  add_foreign_key "project_types", "sections"
  add_foreign_key "projects", "sections"
  add_foreign_key "roles", "people"
  add_foreign_key "roles", "positions"
  add_foreign_key "roles", "projects"
  add_foreign_key "slides", "projects"
end
