class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.timestamp :scored_at
      t.references :game, index: true
      t.references :team, index: true
      t.references :position, index: true
      t.references :player, index: true

      t.timestamps
    end
  end
end
