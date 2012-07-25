class Task < ActiveRecord::Base
  belongs_to :customer
  has_many :sub_times, :order => "start"

  after_initialize :init

  def init
    self.completed = false
  end
end
