class EventsController < ApplicationController
  before_action :get_event, only: [:edit, :update, :destroy]
  
  # GET /events/
  def index
    begin
      current_datetime = Time.zone.parse(params[:date]).getutc
    rescue
      current_datetime = Time.zone.now
    end
    
    # Get events
    beginning_of_month = current_datetime.beginning_of_month
    end_of_month =  current_datetime.end_of_month
    @events = current_user.events.where('start_date >= ? AND start_date <= ?', beginning_of_month, end_of_month).order(start_date: :asc)
    
    # Get month days for Calendar
    begining_of_the_week = current_datetime.at_beginning_of_month.wday
    empty_days = Array.new(begining_of_the_week > 0 ? begining_of_the_week-1 : 0) { nil }
    
    days_in_the_month = current_datetime.end_of_month.day
    calendar_days = Array.new(days_in_the_month) {|i| i+1 }
    
    # Get days of events for Calendar
    event_days = []
    @events.map { |event| event_days << event.start_date.day }
    
    @date = {
      year: current_datetime.year,
      month: current_datetime.strftime("%B"),
      current_date: current_datetime,
      days: empty_days + calendar_days,
      is_current_month: DateTime.now >= beginning_of_month &&  DateTime.now <= end_of_month,
      event_days: event_days.uniq
    }
  end
  
  # GET /events/:id
  def edit
    respond_to do |format|
      format.js { render 'edit', layout: false }
    end
  end
  
  # PUT/PATCH /events/:id
  def update
    updated_event_params = {
      title: event_params[:title],
      description: event_params[:description],
      start_date: get_utc_datetime(event_params[:date], event_params[:start_date]),
      end_date: get_utc_datetime(event_params[:date], event_params[:end_date])
    }
    
    if @event.update(updated_event_params)
      render js: "window.location = '#{events_path}'"
    else
      render 'edit', layout: false
    end
  end
  
  # POST /events
  def create
    event = Event.new(event_params.except(:date))
    event.user = current_user
    event.start_date = get_utc_datetime(event_params[:date], event_params[:start_date])
    event.end_date = get_utc_datetime(event_params[:date], event_params[:end_date])
    
    if event.save
      render js: "window.location = '#{events_path}'"
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /events/:id
  def destroy
    @event.destroy
    redirect_to events_path
  end
  
  private
    def get_event
      @event = Event.find(params[:id])
    end
    
    def get_utc_datetime(date, time)
      return nil if date.blank? || time.blank?
      
      begin
        # Get Datetime in UTC
        Time.zone.parse("#{date} #{time}").getutc
      rescue
        nil
      end
    end
    
    def event_params
      params.require(:event).permit(:title, :description, :date, :start_date, :end_date)
    end
end
