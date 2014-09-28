class DropPositionsGoals < ActiveRecord::Migration
  def change
  	drop_table :positions 
  	drop_table :goals
  end
end
