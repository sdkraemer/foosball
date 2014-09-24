class DefaultGoalQuantity < ActiveRecord::Migration
  def change
  	change_column :goals, :quantity, :integer, :default => 1
  end
end
