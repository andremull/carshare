class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.text :comment
      t.integer :star, default: 1
      t.references :car, foreign_key: true
      t.references :reservation, foreign_key: true
      t.references :renter, foreign_key: { to_table: :users }
      t.references :owner, foreign_key: { to_table: :users }
      t.string :type

      t.timestamps
    end
  end
end
