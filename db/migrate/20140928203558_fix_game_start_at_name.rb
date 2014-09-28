class FixGameStartAtName < ActiveRecord::Migration
  def change
  	change_table :games do |t|
  		t.rename :started_at, :completed_at
  	end
  end
end
