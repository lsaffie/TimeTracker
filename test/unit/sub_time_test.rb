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

require 'test_helper'

class SubTimeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
