class AddLocationToCars < ActiveRecord::Migration[5.1]
  def change
    add_column :cars, :location, :string
  end
end
