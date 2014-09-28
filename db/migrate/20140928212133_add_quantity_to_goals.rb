class AddQuantityToGoals < ActiveRecord::Migration
  def change
  	add_column :goals, :quantity, :integer, :default => 1
  end
end
