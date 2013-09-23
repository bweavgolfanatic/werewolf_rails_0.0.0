class CreateKills < ActiveRecord::Migration
  def change
    create_table :kills do |t|
      t.string :killerID
      t.string :victimID
      t.string :timestamp
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
