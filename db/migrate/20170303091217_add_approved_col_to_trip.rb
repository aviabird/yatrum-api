class AddApprovedColToTrip < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :approved, :boolean, default: false
  end
end
