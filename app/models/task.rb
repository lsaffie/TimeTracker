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

  has_many :sub_times

  after_create :init

  def get_total
    ((Time.now - self.start_at)/60).ceil
  end

  def set_total_time
    self.update_attributes!(:total => (self.end_at-self.start_at)/60)
  end

  def active?
    self.end_at.nil? ? true : false
  end

  def total_to_hrs
    (total.to_f/60)
  end

  def self.total_time
    self.all.sum(&:total_to_hrs)
  end

  def group_by_criteria
    start_at.to_date.to_s(:db)
  end

  def self.end_all
    tasks = Task.where(:end_at => nil)
    tasks.each {|t| t.update_attributes!(:end_at => Time.now, :total => t.get_total)}
  end

  private

  def init
    self.completed = false
    self.start_at = Time.now
    self.save!
  end

end
