class AddInvoicedAtToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :invoiced_at, :datetime
  end

  def self.down
    remove_column :tasks, :invoiced_at
  end
end
