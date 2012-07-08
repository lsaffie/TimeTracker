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

  def start_link(task)
    if task.sub_times.empty?
      eval = true
    elsif !task.sub_times.last.nil?
      eval = task.sub_times.last.start.nil? || !task.sub_times.last.end.nil?
    else
      eval = false
    end
    link_to_if eval, 'start', new_customer_task_sub_time_path(task.customer, task)
  end

  def stop_link(task)
    if !task.sub_times.last.nil?
      eval = task.sub_times.last.end.nil?
      link_to_if eval, 'stop', stop_customer_task_sub_time_path(task.customer, task, task.sub_times.last)
    end
  end

end
