class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.string :name
      t.string :icon
      t.string :icon_hex
      t.timestamps
    end
  end
end
