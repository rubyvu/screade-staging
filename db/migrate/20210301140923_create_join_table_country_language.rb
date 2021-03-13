class CreateJoinTableCountryLanguage < ActiveRecord::Migration[6.1]
  def change
    create_join_table :countries, :languages do |t|
      t.index [:country_id, :language_id]
    end
  end
end
