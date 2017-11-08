class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |t|
      t.string :listing_name
      t.string :car_type
      t.string :transmission
      t.integer :doors_num
      t.text :summary
      t.integer :price
      t.boolean :active
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
