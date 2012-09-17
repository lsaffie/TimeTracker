class TasksController < ApplicationController
  require 'csv'

  # GET /tasks
  # GET /tasks.xml
  def index
    @customer = Customer.find(params[:customer_id])
    @new_task = @customer.tasks.build
    @tasks = @customer.tasks(:order => "created_at").where(:completed => false)
    @completed_tasks = @customer.tasks(:order => "created_at").
      where(:completed => true)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
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
      if @task.save
        if !start.nil?
          @task.save
          SubTime.end_all
          @sub_time = SubTime.new
          @sub_time.start = Time.now
          @sub_time.save!
          @task.sub_times << @sub_time
        end

        format.html { redirect_to(customer_tasks_path(@task.customer), :notice => 'Task was successfully created.') }
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

  def summary
    @customer = Customer.find(params[:customer_id])
    subtimes= []
    @customer.tasks.each do |t|
      get_subtimes(t).each do |tt|
        subtimes << tt
      end
    end
    @grouped_subtimes = subtimes.group_by(&:group_by_criteria)

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate do |csv|
          cols = ["Name", "Start", "End", "Total(min)"]
          csv << cols

          @grouped_subtimes.each do |start, subtimes|
            subtimes.each do |subtime|
              csv << [subtime.task.name, subtime.start.to_s(:short), subtime.end.to_s(:short), ((subtime.end-subtime.start)/60).ceil]
            end
          end
        end
        send_data csv_string, :type => 'text/plain',
          :filename => 'TimeTracker.csv',
          :disposition => 'attachment'
      end
    end

  end

  def complete_all
    @customer = Customer.find(params[:customer_id])
    @tasks = @customer.tasks.where(:completed => false)
    @tasks.each {|t| t.update_attributes!(:completed => true, :completed_at => Time.now)}
    redirect_to customer_tasks_path(@customer)
  end

  private
  def get_subtimes(task)
    if params["start"] && params[:end]
      start_date=Report.get_date(params["start"])
      end_date=Report.get_date(params["end"])
      return task.sub_times.find(:all, :conditions => ['DATE(start) >= ? and DATE(start) <= ?',start_date, end_date])
    else
      return task.sub_times
    end
  end
end
