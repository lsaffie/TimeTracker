class AddInvoicedToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :invoiced, :boolean
  end

  def self.down
    remove_column :tasks, :invoiced
  end
end
