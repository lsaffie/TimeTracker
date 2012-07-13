class SubTime < ActiveRecord::Base
  belongs_to :task

  def group_by_criteria
    start.to_date.to_s(:db)
  end

  def to_mins
    ((self.end- self.start)/60).ceil
  end

  def to_hrs
    ((self.end- self.start)/3600).round(2)
  end
end
