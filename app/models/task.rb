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
  has_many :sub_times, :order => "start"
  validates :name,
            :presence => true

  after_initialize :init

  def init
    self.completed = false
  end

  def set_total
    total = 0
    self.sub_times.each {|sb| total += sb.to_mins}
    self.total = total
    self.save!
  end
end
