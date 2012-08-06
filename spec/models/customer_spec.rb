require 'spec_helper'

describe Customer do

  it 'can be instantiated' do
    Customer.new.should be_an_instance_of(Customer)
  end

  it 'can be saved successfully' do
    Customer.create.should be_persisted
  end

  it 'should instansiate a customer with factory girl' do
    customer = FactoryGirl.build(:customer)
    puts customer.name
  end

end
