class TasksController < ApplicationController
  require 'csv'

  # GET /tasks
  # GET /tasks.xml
  def index
    @customer = Customer.find(params[:customer_id])
    @new_task = @customer.tasks.build
    @tasks = @customer.tasks(:order => "created_at").where(:completed => false)
    @completed_tasks = Rails.cache.fetch("completed_tasks", :expires_in => 24.hours) {@customer.tasks(:order => "created_at").where(:completed => true).group_by(&:completed_at)}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
      format.json { render :json => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @customer = Customer.find(params[:customer_id])
    @task = @customer.tasks.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @customer = Customer.find(params[:customer_id])
    @task = @customer.tasks.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])
    @task.customer_id = params[:customer_id]
    start = params['start']

    if @task.invoiced?
      @task.invoiced_at = Time.now
    end

    respond_to do |format|
      Task.end_all
      if @task.save
        format.html { redirect_to(customer_tasks_path(@task.customer), :notice => 'Task was successfully created.') }
        format.json { redirect_to(customer_tasks_path(@task.customer), :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @customer = Customer.find(params[:customer_id])
    @task = @customer.tasks.find(params[:id])

    if @task.invoiced?
      @task.invoiced_at = Time.now
    end

    respond_to do |format|
      if @task.update_attributes(params[:task])
        @task.set_total_time
        format.html { redirect_to(customer_task_path(@customer, @task), :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
        format.json  { head :ok } # used by best in place
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
        format.json { render :json => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @customer = Customer.find(params[:customer_id])
    @task = @customer.tasks.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to customer_tasks_path(@customer) }
      format.xml  { head :ok }
    end
  end

  def complete
    @customer = Customer.find(params[:customer_id])
    @task = @customer.tasks.find(params[:id])
    @task.update_attributes(:completed => true,
                            :completed_at => Time.now)

    respond_to do |format|
      format.html { redirect_to customer_tasks_path(@customer) }
      format.xml  { head :ok }
    end
  end

  def uncomplete
    @customer = Customer.find(params[:customer_id])
    @task = @customer.tasks.find(params[:id])
    @task.update_attributes(:completed => false,
                            :completed_at => nil)

    respond_to do |format|
      format.html { redirect_to customer_tasks_path(@customer) }
      format.xml  { head :ok }
    end
  end

  def complete_all
    @customer = Customer.find(params[:customer_id])
    @tasks = @customer.tasks.where(:completed => false)
    @tasks.each {|t| t.update_attributes!(:completed => true, :completed_at => Time.now)}
    redirect_to customer_tasks_path(@customer)
  end

  def stop
    customer = Customer.find(params[:customer_id])
    task = Task.find params[:id]
    task.update_attributes!(:end_at => Time.now, :total => task.get_total)
    redirect_to customer_tasks_path(customer)
  end

  def start
    customer = Customer.find(params[:customer_id])
    task = Task.find params[:id]
    task.update_attributes!(:end_at => nil)
    redirect_to customer_tasks_path(customer)
  end

  def chart
    @customer = Customer.find(params[:customer_id])
    tasks = get_tasks_by_date(@customer)
    grouped_tasks = tasks.sort_by(&:start_at).group_by(&:group_by_criteria).collect {|e| [e.first, e.last.sum(&:total_to_hrs)]}

    hours_days_array = grouped_tasks.reverse.take(14)
    @days = hours_days_array.collect {|d| Date.parse(d.first).strftime("%a %d")}
    @hours = hours_days_array.collect {|d| d.last.round(2)}
  end

  def summary
    @customer = Customer.find(params[:customer_id])
    tasks = get_tasks_by_date(@customer)
    @grouped_tasks = tasks.group_by(&:group_by_criteria)

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate do |csv|
          cols = ["Name", "Start", "End", "Total(min)"]
          csv << cols

          @grouped_tasks.each do |start, tasks|
            tasks.each do |task|
              csv << [task.name, task.start_at.to_s(:short), task.end_at.to_s(:short), ((task.end_at-task.start_at)/60).ceil]
            end
          end
        end

        send_data csv_string, :type => 'text/plain',
          :filename => 'TimeTracker.csv',
          :filename => 'TimeTracker.csv',
          :disposition => 'attachment'
      end
    end
  end

private
  def get_tasks_by_date(customer)
    if params["start"] && params[:end]
      start_date=Report.get_date(params["start"])
      end_date=Report.get_date(params["end"])
      return customer.tasks.find(:all, :conditions => ['DATE(start_at) >= ? and DATE(start_at) <= ?',start_date, end_date])
    else
      return customer.tasks
    end
  end


end
