module TasksHelper
  def customer_name(id)
    customer=Customer.find id
    customer.name
  end
end
