class Task < ActiveRecord::Base
  belongs_to :customer
  has_many :sub_times
end
