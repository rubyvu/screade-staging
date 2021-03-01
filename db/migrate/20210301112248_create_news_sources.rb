class CreateNewsSources < ActiveRecord::Migration[6.1]
  def change
    create_table :news_sources do |t|
      t.string :source_identifier, null: false
      t.string :name
      t.string :language
      t.integer :country_id, null: false
      t.timestamps
      t.index :source_identifier, unique: true
      t.index :country_id
    end
  end
end
