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

ActiveRecord::Schema.define(version: 2021_10_27_072240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "breaking_news", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "post_id"
  end

  create_table "chat_audio_rooms", force: :cascade do |t|
    t.integer "chat_id", null: false
    t.string "sid", null: false
    t.string "status", default: "in-progress", null: false
    t.string "name", null: false
    t.integer "participants_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_id"], name: "index_chat_audio_rooms_on_chat_id"
    t.index ["name"], name: "index_chat_audio_rooms_on_name", unique: true
  end

  create_table "chat_memberships", force: :cascade do |t|
    t.integer "chat_id", null: false
    t.integer "user_id", null: false
    t.string "role", default: "user", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "unread_messages_count", default: 0, null: false
    t.boolean "is_mute", default: false, null: false
    t.index ["chat_id"], name: "index_chat_memberships_on_chat_id"
    t.index ["user_id"], name: "index_chat_memberships_on_user_id"
  end

  create_table "chat_messages", force: :cascade do |t|
    t.integer "chat_id", null: false
    t.integer "user_id", null: false
    t.string "message_type", null: false
    t.string "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "asset_source_id"
    t.string "asset_source_type"
    t.integer "chat_room_source_id"
    t.string "chat_room_source_type"
    t.index ["chat_id"], name: "index_chat_messages_on_chat_id"
    t.index ["message_type"], name: "index_chat_messages_on_message_type"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "chat_video_rooms", force: :cascade do |t|
    t.integer "chat_id", null: false
    t.string "sid", null: false
    t.string "status", default: "in-progress", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "participants_count", default: 0, null: false
    t.index ["chat_id"], name: "index_chat_video_rooms_on_chat_id"
    t.index ["name"], name: "index_chat_video_rooms_on_name", unique: true
  end

  create_table "chats", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "owner_id", null: false
    t.string "access_token", null: false
    t.index ["access_token"], name: "index_chats_on_access_token", unique: true
    t.index ["owner_id"], name: "index_chats_on_owner_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "message"
    t.integer "user_id", null: false
    t.integer "source_id", null: false
    t.string "source_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "lits_count", default: 0, null: false
    t.integer "comment_id"
    t.index ["source_id"], name: "index_comments_on_source_id"
  end

  create_table "contact_us_requests", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "username", null: false
    t.string "email", null: false
    t.string "subject", null: false
    t.text "message", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "resolved_at"
    t.string "resolved_by"
    t.string "version", default: "0"
  end

  create_table "countries", force: :cascade do |t|
    t.string "title", null: false
    t.string "code", null: false
    t.boolean "is_national_news", default: false
    t.index ["code"], name: "index_countries_on_code", unique: true
  end

  create_table "countries_languages", id: false, force: :cascade do |t|
    t.bigint "country_id", null: false
    t.bigint "language_id", null: false
    t.index ["country_id", "language_id"], name: "index_countries_languages_on_country_id_and_language_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "access_token", null: false
    t.integer "owner_id", null: false
    t.string "name"
    t.string "operational_system", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "push_token"
    t.index ["access_token"], name: "index_devices_on_access_token", unique: true
    t.index ["owner_id"], name: "index_devices_on_owner_id"
    t.index ["push_token"], name: "index_devices_on_push_token"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "code", null: false
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_languages_on_code", unique: true
  end

  create_table "languages_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "language_id", null: false
    t.index ["user_id", "language_id"], name: "index_languages_users_on_user_id_and_language_id"
  end

  create_table "lits", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "source_id", null: false
    t.string "source_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["source_id", "source_type", "user_id"], name: "index_lits_on_source_id_and_source_type_and_user_id", unique: true
  end

  create_table "news_articles", force: :cascade do |t|
    t.integer "country_id", null: false
    t.datetime "published_at", null: false
    t.string "author"
    t.string "title", null: false
    t.text "description"
    t.string "url", null: false
    t.string "img_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "news_source_id"
    t.integer "comments_count", default: 0, null: false
    t.integer "lits_count", default: 0, null: false
    t.integer "views_count", default: 0, null: false
    t.string "detected_language"
    t.index ["country_id"], name: "index_news_articles_on_country_id"
    t.index ["detected_language"], name: "index_news_articles_on_detected_language"
    t.index ["lits_count"], name: "index_news_articles_on_lits_count"
    t.index ["url"], name: "index_news_articles_on_url", unique: true
  end

  create_table "news_articles_categories", id: false, force: :cascade do |t|
    t.bigint "news_article_id", null: false
    t.bigint "news_category_id", null: false
    t.index ["news_article_id", "news_category_id"], name: "index_news_articles_categories_on_ids"
  end

  create_table "news_articles_topics", id: false, force: :cascade do |t|
    t.bigint "news_article_id", null: false
    t.bigint "topic_id", null: false
    t.index ["news_article_id", "topic_id"], name: "index_news_articles_topics_on_news_article_id_and_topic_id"
  end

  create_table "news_categories", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_news_categories_on_title", unique: true
  end

  create_table "news_sources", force: :cascade do |t|
    t.string "source_identifier", null: false
    t.string "name"
    t.integer "language_id", null: false
    t.integer "country_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_news_sources_on_country_id"
    t.index ["source_identifier"], name: "index_news_sources_on_source_identifier", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "recipient_id", null: false
    t.integer "source_id", null: false
    t.string "source_type", null: false
    t.boolean "is_viewed", default: false
    t.string "message", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sender_id"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
  end

  create_table "post_groups", force: :cascade do |t|
    t.integer "group_id", null: false
    t.string "group_type", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_post_groups_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.boolean "is_notification", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "comments_count", default: 0, null: false
    t.integer "lits_count", default: 0, null: false
    t.integer "views_count", default: 0, null: false
    t.integer "source_id", null: false
    t.string "source_type", null: false
    t.boolean "is_approved", default: true
  end

  create_table "que_jobs", comment: "4", force: :cascade do |t|
    t.integer "priority", limit: 2, default: 100, null: false
    t.datetime "run_at", default: -> { "now()" }, null: false
    t.text "job_class", null: false
    t.integer "error_count", default: 0, null: false
    t.text "last_error_message"
    t.text "queue", default: "default", null: false
    t.text "last_error_backtrace"
    t.datetime "finished_at"
    t.datetime "expired_at"
    t.jsonb "args", default: [], null: false
    t.jsonb "data", default: {}, null: false
    t.index ["args"], name: "que_jobs_args_gin_idx", opclass: :jsonb_path_ops, using: :gin
    t.index ["data"], name: "que_jobs_data_gin_idx", opclass: :jsonb_path_ops, using: :gin
    t.index ["job_class"], name: "que_scheduler_job_in_que_jobs_unique_index", unique: true, where: "(job_class = 'Que::Scheduler::SchedulerJob'::text)"
    t.index ["queue", "priority", "run_at", "id"], name: "que_poll_idx", where: "((finished_at IS NULL) AND (expired_at IS NULL))"
    t.check_constraint "(char_length(last_error_message) <= 500) AND (char_length(last_error_backtrace) <= 10000)", name: "error_length"
    t.check_constraint "(jsonb_typeof(data) = 'object'::text) AND ((NOT (data ? 'tags'::text)) OR ((jsonb_typeof((data -> 'tags'::text)) = 'array'::text) AND (jsonb_array_length((data -> 'tags'::text)) <= 5) AND que_validate_tags((data -> 'tags'::text))))", name: "valid_data"
    t.check_constraint "char_length(queue) <= 100", name: "queue_length"
    t.check_constraint "jsonb_typeof(args) = 'array'::text", name: "valid_args"
    t.check_constraint nil, name: "job_class_length"
  end

  create_table "que_lockers", primary_key: "pid", id: :integer, default: nil, force: :cascade do |t|
    t.integer "worker_count", null: false
    t.integer "worker_priorities", null: false, array: true
    t.integer "ruby_pid", null: false
    t.text "ruby_hostname", null: false
    t.text "queues", null: false, array: true
    t.boolean "listening", null: false
    t.check_constraint "(array_ndims(queues) = 1) AND (array_length(queues, 1) IS NOT NULL)", name: "valid_queues"
    t.check_constraint "(array_ndims(worker_priorities) = 1) AND (array_length(worker_priorities, 1) IS NOT NULL)", name: "valid_worker_priorities"
  end

  create_table "que_scheduler_audit", primary_key: "scheduler_job_id", id: :bigint, default: nil, comment: "6", force: :cascade do |t|
    t.datetime "executed_at", null: false
  end

  create_table "que_scheduler_audit_enqueued", id: false, force: :cascade do |t|
    t.bigint "scheduler_job_id", null: false
    t.string "job_class", limit: 255, null: false
    t.string "queue", limit: 255
    t.integer "priority"
    t.jsonb "args", null: false
    t.bigint "job_id"
    t.datetime "run_at"
    t.index ["args"], name: "que_scheduler_audit_enqueued_args"
    t.index ["job_class"], name: "que_scheduler_audit_enqueued_job_class"
    t.index ["job_id"], name: "que_scheduler_audit_enqueued_job_id"
  end

  create_table "que_values", primary_key: "key", id: :text, force: :cascade do |t|
    t.jsonb "value", default: {}, null: false
    t.check_constraint "jsonb_typeof(value) = 'object'::text", name: "valid_value"
  end

  create_table "settings", force: :cascade do |t|
    t.string "font_family"
    t.string "font_style"
    t.boolean "is_notification", default: true
    t.boolean "is_images", default: true
    t.boolean "is_videos", default: true
    t.boolean "is_posts", default: true
    t.integer "user_id", null: false
    t.boolean "is_email"
    t.boolean "is_current_location", default: false, null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "squad_requests", force: :cascade do |t|
    t.integer "receiver_id"
    t.integer "requestor_id"
    t.datetime "accepted_at"
    t.datetime "declined_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["receiver_id", "requestor_id"], name: "index_squad_requests_on_receiver_id_and_requestor_id"
  end

  create_table "stream_comments", force: :cascade do |t|
    t.text "message"
    t.integer "user_id"
    t.integer "stream_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_stream_comments_on_user_id"
  end

  create_table "streams", force: :cascade do |t|
    t.string "title", null: false
    t.boolean "is_private", default: true, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "access_token", null: false
    t.string "error_message"
    t.string "status", default: "in-progress", null: false
    t.integer "group_id"
    t.string "group_type"
    t.integer "stream_comments_count", default: 0, null: false
    t.integer "views_count", default: 0, null: false
    t.integer "lits_count", default: 0, null: false
    t.string "mux_stream_id"
    t.string "mux_stream_key"
    t.string "mux_playback_id"
    t.index ["status"], name: "index_streams_on_status"
    t.index ["user_id"], name: "index_streams_on_user_id"
  end

  create_table "streams_users", id: false, force: :cascade do |t|
    t.bigint "stream_id", null: false
    t.bigint "user_id", null: false
    t.index ["stream_id", "user_id"], name: "index_streams_users_on_stream_id_and_user_id", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.integer "parent_id", null: false
    t.string "parent_type", null: false
    t.string "title", null: false
    t.boolean "is_approved", default: true
    t.integer "nesting_position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "suggester_id"
    t.index ["parent_id"], name: "index_topics_on_parent_id"
  end

  create_table "user_images", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_private", default: true
  end

  create_table "user_locations", force: :cascade do |t|
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_locations_on_user_id"
  end

  create_table "user_security_questions", force: :cascade do |t|
    t.string "title", null: false
    t.string "question_identifier", null: false
    t.index ["question_identifier"], name: "index_user_security_questions_on_question_identifier", unique: true
  end

  create_table "user_topic_subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "source_id", null: false
    t.string "source_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "source_id", "source_type"], name: "index_user_topic_subscriptions_on_user_and_source", unique: true
  end

  create_table "user_videos", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_private", default: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.date "birthday"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username", null: false
    t.integer "user_security_question_id", null: false
    t.string "security_question_answer", null: false
    t.integer "country_id", null: false
    t.string "middle_name"
    t.datetime "blocked_at"
    t.string "blocked_comment"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "views", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "source_id", null: false
    t.string "source_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["source_id", "source_type", "user_id"], name: "index_views_on_source_id_and_source_type_and_user_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "que_scheduler_audit_enqueued", "que_scheduler_audit", column: "scheduler_job_id", primary_key: "scheduler_job_id", name: "que_scheduler_audit_enqueued_scheduler_job_id_fkey"
end
