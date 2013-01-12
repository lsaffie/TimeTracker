class SetStartAtAndEndAt < ActiveRecord::Migration
  def up
    Task.all.each do |task|
      if task.sub_times.any?
        task.start_at = task.sub_times.last.start
        task.end_at = task.sub_times.last.end
        if task.total.nil?
          task.total = task.end_at - task.start_at
        end
        task.save!
      else
        task.delete
      end
    end
  end

  def down
  end
end
