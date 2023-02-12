class AddSignInRedirectLocationToSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :settings, :sign_in_redirect_location, :string, null: false, default: 'Home'
  end
end
