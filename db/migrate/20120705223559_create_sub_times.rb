class CreateSubTimes < ActiveRecord::Migration
  def self.up
    create_table :sub_times do |t|
      t.datetime :start
      t.datetime :end
      t.integer :task_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sub_times
  end
end
