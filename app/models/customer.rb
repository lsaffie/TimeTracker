# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Customer < ActiveRecord::Base
  has_many :tasks, :order =>'completed_at DESC, created_at DESC'

  accepts_nested_attributes_for :tasks
end
