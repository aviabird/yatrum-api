class AddProfilePictureUrlToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :profile_picture_url, :string
    add_column :users, :cover_photo_url, :string
  end
end
