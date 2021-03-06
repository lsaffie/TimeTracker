class SubTimesController < ApplicationController
  # GET /sub_times
  # GET /sub_times.xml
  def index
    @customer = Customer.find(params[:customer_id])
    @task = Task.find(params[:task_id])
    @sub_times = @task.sub_times

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sub_times }
      format.js { render :layout => false }
      format.json { render :json => @sub_times }
    end
  end

  # GET /sub_times/1
  # GET /sub_times/1.xml
  def show
    @customer = Customer.find(params[:customer_id])
    @task = Task.find(params[:task_id])
    @sub_time = SubTime.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sub_time }
      format.json  { head :ok } # used by best in place
    end
  end

  # GET /sub_times/new
  # GET /sub_times/new.xml
  def new
    @sub_time = SubTime.new
    start
  end

  # GET /sub_times/1/edit
  def edit
    @customer = Customer.find(params[:customer_id])
    @task = Task.find(params[:task_id])
    @sub_time = SubTime.find(params[:id])
  end

  # POST /sub_times
  # POST /sub_times.xml
  def create
    @sub_time = SubTime.new(params[:sub_time])

    respond_to do |format|
      if @sub_time.save
        format.html { redirect_to(@sub_time, :notice => 'Sub time was successfully created.') }
        format.xml  { render :xml => @sub_time, :status => :created, :location => @sub_time }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sub_time.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sub_times/1
  # PUT /sub_times/1.xml
  def update
    @customer = Customer.find(params[:customer_id])
    @task = Task.find(params[:task_id])
    @sub_time = SubTime.find(params[:id])

    respond_to do |format|
      if @sub_time.update_attributes(params[:sub_time])
        @task.set_total
        format.html { redirect_to(customer_task_sub_times_path(@customer, @task), :notice => 'Sub time was successfully updated.') }
        format.xml  { head :ok }
        format.js 
        format.json  { head :ok } # used by best in place
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sub_time.errors, :status => :unprocessable_entity }
        format.json { render :json => @sub_time.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_times/1
  # DELETE /sub_times/1.xml
  def destroy
    @sub_time = SubTime.find(params[:id])
    @sub_time.destroy

    respond_to do |format|
      format.html { redirect_to(sub_times_url) }
      format.xml  { head :ok }
    end
  end

  #Marks subtask as stopped
  def stop
    @sub_time = SubTime.find(params[:id])
    @sub_time.end = Time.now

    if @sub_time.save
      @sub_time.task.set_total
      redirect_to customer_tasks_url(@sub_time.task.customer)
    end
  end

  private
  #Marks subtask as started
  def start
    @sub_time.start = Time.now
    @sub_time.task_id = params[:task_id]
    SubTime.end_all
    if @sub_time.save
      redirect_to customer_tasks_url(@sub_time.task.customer)
    end
  end

end
