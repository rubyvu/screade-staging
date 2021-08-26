class RemoveUploaderFieldsFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :profile_picture
    remove_column :users, :profile_picture_hex
    remove_column :users, :banner_picture
    remove_column :users, :banner_picture_hex
  end
end
