class AddPublicIdToPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :public_id, :string
  end
end
