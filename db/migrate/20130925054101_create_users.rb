class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.integer :total_score
      t.integer :high_score

      t.timestamps
    end
  end
end
