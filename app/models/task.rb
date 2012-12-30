# == Schema Information
#
# Table name: tasks
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  total        :integer          default(0)
#  customer_id  :integer
#  completed    :boolean
#  completed_at :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  invoiced     :boolean
#  invoiced_at  :datetime
#

class Task < ActiveRecord::Base
  belongs_to :customer
  validates :name,
            :presence => true

  after_initialize :init
  before_save :before_saved

  def get_total
    ((Time.now - self.start_at)/60).ceil
  end

  def total_to_hrs
    (total/3600).round(2)
  end

  def self.total_time
    self.all.sum(&:total_to_hrs)
  end

  def group_by_criteria
    start_at.to_date.to_s(:db)
  end

  private

  def before_saved
    self.start_at = Time.now
  end

  def init
    self.completed = false
  end

end
