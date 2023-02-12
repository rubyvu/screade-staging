class CreateNewsApiLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :news_api_logs do |t|
      t.string :request_target, null: false
      t.string :country_code
      t.string :category
      t.boolean :success
      t.timestamps
    end
  end
end
