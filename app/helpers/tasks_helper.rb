module TasksHelper
  @@previous_time = Time.now

  def customer_name
    customer=Customer.find(params[:customer_id])
    customer.name
  end

  def get_class(task)
    task.end_at.nil? ? "running" : ""
  end

  def print_invoiced_row(task)
    if task.invoiced? && task.invoiced_at?
      haml_tag(:b,"Invoiced:")
      haml_concat(task.invoiced_at.to_s(:long))
    end
  end

  def start_link(task)
    link_to "start", start_customer_task_path(task.customer, task)
  end

  def stop_link(task)
    link_to "stop", stop_customer_task_path(task.customer, task)
  end

  def print_running_task_time(task)
    if task.active?
      current = (Time.now - task.start_at) /60
      haml_tag(:td, current.to_i)
    else
      haml_tag(:td, "")
    end
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

  def total(tasks)
    tasks.sum(&:total_to_hrs).round(2)
  end

  def get_grand_total(grouped_tasks)
    grand = 0
    grouped_tasks.each do |created_at, tasks|
      grand += tasks.sum(&:total)
    end
    haml_concat(grand.to_f/60)
  end

  def tasks_link
    if @customer && @customer.id
      haml_tag(:a, '| tasks', :href => customer_tasks_path(@customer))
      haml_tag(:a, '| summary', :href => summary_customer_tasks_path(@customer))
      haml_tag(:a, '| chart', :href => chart_customer_tasks_path(@customer))
      haml_tag(:a, '| reports', :href => customer_reports_path(@customer))
    end
  end

  def display_end_and_total_time(subtime)
    unless subtime.end.nil?
      haml_tag :td, subtime.end.to_s(:short)
      haml_tag :td, ((subtime.end-subtime.start)/60).ceil
    end

  end

end
