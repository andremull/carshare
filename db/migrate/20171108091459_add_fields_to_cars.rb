class AddFieldsToCars < ActiveRecord::Migration[5.1]
  def change
    add_column :cars, :latitude, :float
    add_column :cars, :longitude, :float
  end
end
