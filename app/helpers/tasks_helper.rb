module TasksHelper
  def customer_name
    customer=Customer.find(params[:customer_id])
    customer.name
  end

  def get_class(task)
    return "disabled" if task.invoiced

    unless task.sub_times.empty?
      if task.sub_times.last.end.nil?
        return "running"
      end
    end
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

  def print_running_task_time(task)
    current = ''
    if !task.sub_times.last.nil?
      subtime = task.sub_times.last
      if subtime.end.nil?
        current = (Time.now - subtime.start) / 60
      end
    end

    haml_tag(:td, current.to_i)
  end

end
