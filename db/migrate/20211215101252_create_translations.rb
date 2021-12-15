class CreateTranslations < ActiveRecord::Migration[6.1]
  def change
    create_table :translations do |t|
      t.bigint :translatable_id, null: false
      t.string :translatable_type, null: false
      t.bigint :language_id, null: false
      t.string :field_name, null: false
      t.text :result
      t.timestamps
      
      t.index [:translatable_id, :translatable_type, :language_id, :field_name], name: 'translations_unique_index'
    end
  end
end
