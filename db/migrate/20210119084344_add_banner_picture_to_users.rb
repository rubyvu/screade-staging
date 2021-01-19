class AddBannerPictureToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :banner_picture, :string
    add_column :users, :banner_picture_hex, :string
  end
end
