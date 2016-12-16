class AddInstagramAccessTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :instagram_access_token, :string
  end
end
