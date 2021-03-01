class CreateLanguages < ActiveRecord::Migration[6.1]
  def change
    create_table :languages do |t|
      t.string :code, null: false
      t.string :title, null: false
      t.timestamps
      t.index :code, unique: true
    end
  end
end
