class CreateBreakingNews < ActiveRecord::Migration[6.1]
  def change
    create_table :breaking_news do |t|
      t.string :title, null: false
      t.boolean :is_active, default: false
      t.integer :country_id, null: false
      t.timestamps
      t.index :country_id
    end
  end
end
