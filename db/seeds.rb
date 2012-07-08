# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#

#Default user
User.create :email => 'luis@saffie.ca',
            :password => 'firetruck',
            :password_confirmation => 'firetruck'

#Default Customers
Customer.create ([{ :name => 'eHealth' }, { :name => 'Handy Metrics' }])
