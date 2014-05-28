class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.references :game, index: true

      t.timestamps
    end
  end
end
