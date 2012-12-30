class RemoveSubTimesTable < ActiveRecord::Migration
  def up
    #drop_table :sub_times
  end

  def down
    create_table :sub_times do |t|
      t.datetime :start
      t.datetime :end
      t.integer :task_id

      t.timestamps
    end
  end
end
