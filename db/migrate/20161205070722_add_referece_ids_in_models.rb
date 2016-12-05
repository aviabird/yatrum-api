class AddRefereceIdsInModels < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :user_id, :integer
    add_column :cities, :trip_id, :integer
    add_column :places, :city_id, :integer
    add_column :pictures, :place_id, :integer
  end
end
