class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :game, index: true
      t.references :position, index: true

      t.timestamps
    end
  end
end
