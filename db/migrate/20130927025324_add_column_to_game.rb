class AddColumnToGame < ActiveRecord::Migration
  def change
    add_column :games, :day_state, :string
  end
end
