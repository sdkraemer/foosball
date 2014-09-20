class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :striker_id
      t.integer :midfield_id
      t.integer :defense_id
      t.integer :goalie_id

      t.timestamps
    end
  end
end
