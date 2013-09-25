class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :userID
      t.string :type
      t.integer :isDead
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
