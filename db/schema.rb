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

ActiveRecord::Schema.define(version: 2024_08_24_021556) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "announcements", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "answers", force: :cascade do |t|
    t.string "content"
    t.integer "question_id", null: false
    t.integer "response_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["response_id"], name: "index_answers_on_response_id"
  end

  create_table "credit_answers", force: :cascade do |t|
    t.integer "answer"
    t.integer "credit_question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "response_id"
    t.binary "file_upload"
    t.integer "credit_section_id"
    t.float "credit"
    t.float "verified_credit"
    t.float "verified_count"
    t.boolean "is_upload"
    t.index ["credit_question_id"], name: "index_credit_answers_on_credit_question_id"
    t.index ["credit_section_id"], name: "index_credit_answers_on_credit_section_id"
    t.index ["response_id"], name: "index_credit_answers_on_response_id"
  end

  create_table "credit_questions", force: :cascade do |t|
    t.string "title"
    t.integer "credit_section_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "max_credit"
    t.float "obt_credit"
    t.boolean "isheader"
    t.integer "header_id"
    t.index ["credit_section_id"], name: "index_credit_questions_on_credit_section_id"
  end

  create_table "credit_sections", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "max_credit"
  end

  create_table "departments", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "full_name"
  end

  create_table "file_uploads", force: :cascade do |t|
    t.binary "file"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "upload_question_id"
    t.integer "response_id"
    t.index ["response_id"], name: "index_file_uploads_on_response_id"
    t.index ["upload_question_id"], name: "index_file_uploads_on_upload_question_id"
  end

  create_table "forms", force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.string "salary"
    t.string "dept"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "template_form_id"
    t.integer "readtime"
    t.text "description"
    t.integer "user_id"
    t.float "credit_req"
    t.integer "fee"
    t.integer "department_id"
    t.index ["department_id"], name: "index_forms_on_department_id"
    t.index ["user_id"], name: "index_forms_on_user_id"
  end

  create_table "homes", force: :cascade do |t|
    t.string "index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "options", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "question_id"
    t.string "role"
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "question_types", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "form_id"
    t.integer "question_type_id"
    t.integer "position"
    t.integer "tab_id"
    t.string "role"
    t.boolean "mandatory", default: false
    t.boolean "is_summary", default: false
    t.index ["form_id"], name: "index_questions_on_form_id"
    t.index ["question_type_id"], name: "index_questions_on_question_type_id"
    t.index ["tab_id"], name: "index_questions_on_tab_id"
  end

  create_table "responses", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "form_id"
    t.float "credit_score"
    t.boolean "validation"
    t.boolean "payment_status"
    t.integer "amount"
    t.boolean "profile_response"
    t.string "app_no"
    t.string "remark"
    t.boolean "eligibility", default: false
    t.string "status", default: "Free"
    t.float "validated_credit_score"
    t.boolean "is_summary", default: false
    t.string "skipped"
    t.boolean "academic_experience"
    t.boolean "professional_experience"
    t.boolean "credit_requirements"
    t.string "undergraduate"
    t.string "postgraduate"
    t.string "phd"
    t.string "postdoc"
    t.string "experience_type"
    t.string "major_awards"
    t.string "acad_exp_comments"
    t.string "prof_exp_comments"
    t.string "credit_req_comments"
    t.index ["form_id"], name: "index_responses_on_form_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "tabs", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tab_no", default: 0
  end

  create_table "upload_questions", force: :cascade do |t|
    t.string "title"
    t.integer "upload_section_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["upload_section_id"], name: "index_upload_questions_on_upload_section_id"
  end

  create_table "upload_sections", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role"
    t.integer "tab_no", default: 1
    t.integer "nav_tab_no", default: 1
    t.string "validator"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "responses"
  add_foreign_key "credit_answers", "credit_questions"
  add_foreign_key "credit_questions", "credit_questions", column: "header_id", on_delete: :cascade
  add_foreign_key "credit_questions", "credit_sections"
  add_foreign_key "file_uploads", "upload_questions"
  add_foreign_key "forms", "users"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "forms"
  add_foreign_key "questions", "question_types"
  add_foreign_key "responses", "users"
  add_foreign_key "upload_questions", "upload_sections"
end
