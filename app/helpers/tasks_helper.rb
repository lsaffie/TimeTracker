module TasksHelper
  def customer_name(id)
    customer=Customer.find id
    customer.name
  end

  def get_class(invoiced)
    return "disabled" if invoiced
  end

  def print_invoiced_row(task)
    if task.invoiced? && task.invoiced_at?
      haml_tag(:b,"Invoiced:")
      haml_concat(task.invoiced_at.to_s(:long))
    end
  end
end
