class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.belongs_to :user
      t.string :alignment
      t.boolean :isDead
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
