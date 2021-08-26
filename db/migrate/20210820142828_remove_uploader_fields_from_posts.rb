class RemoveUploaderFieldsFromPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :image
    remove_column :posts, :image_hex
  end
end
