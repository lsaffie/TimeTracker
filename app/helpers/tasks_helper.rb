module TasksHelper
  @@previous_time = Time.now
  @@grand_total = 0

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


  def to_hrs(amount)
    (amount/3600).round(2)
  end

  def day_row(subtime)
    if subtime.start > @@previous_time
      haml_tag(:tr, :class => "gray_row") do
        haml_tag(:td, "blah")
      end
    end
    @previous_time = subtime.start
  end

  def total(subtimes)
    total = 0
    subtimes.each {|s| total += s.to_hrs}
    @@grand_total += total
    haml_concat(total)
  end

  def get_grand_total
    haml_concat(@@grand_total)
  end

  def tasks_link
    if @customer
      haml_tag(:a, '| tasks', :href => customer_tasks_path(@customer))
      haml_tag(:a, '| summary', :href => summary_customer_tasks_path(@customer))
      haml_tag(:a, '| reports', :href => customer_reports_path(@customer))
    end
  end

end
