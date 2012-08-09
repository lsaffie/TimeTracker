# == Schema Information
#
# Table name: sub_times
#
#  id         :integer          not null, primary key
#  start      :datetime
#  end        :datetime
#  task_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class SubTime < ActiveRecord::Base
  belongs_to :task

  def group_by_criteria
    start.to_date.to_s(:db)
  end

  def total
    to_hrs
  end

  def to_mins
    ((self.end- self.start)/60).ceil
  end

  def to_hrs
    ((self.end- self.start)/3600).round(2)
  end

  def self.end_all
    find_all_by_end(nil).each do |st|
      st.update_attributes!(:end => Time.now) 
      st.task.set_total
    end
  end

end
