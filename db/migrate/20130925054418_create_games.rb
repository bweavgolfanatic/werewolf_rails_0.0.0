class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :createdDate
      t.integer :dayNightFreq
      t.string :day_state

      t.timestamps
    end
  end
end
