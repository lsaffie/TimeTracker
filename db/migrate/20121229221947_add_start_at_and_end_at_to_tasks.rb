class AddStartAtAndEndAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :start_at, :datetime
    add_column :tasks, :end_at, :datetime
  end
end
