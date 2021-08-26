class RemoveUploaderFieldsFromUserImages < ActiveRecord::Migration[6.1]
  def change
    remove_column :user_images, :file
    remove_column :user_images, :file_hex
  end
end
