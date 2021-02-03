class CreateCountries < ActiveRecord::Migration[6.1]
  def change
    create_table :countries do |t|
      t.string :title, null: false
      t.string :code, null: false
      t.index :code, unique: true
    end
  end
end
