class EventsController < ApplicationController
  # before_action :get_event
  
  # GET /events/
  def index
    begin
      current_datetime = Time.parse(params[:date])
    rescue
      current_datetime = DateTime.now
    end
    
    beginning_of_month = current_datetime.beginning_of_month
    end_of_month =  current_datetime.end_of_month
    @events = current_user.events.where('start_date >= ? AND start_date <= ?', beginning_of_month, end_of_month).order(start_date: :asc)
    
    begining_of_the_week = current_datetime.at_beginning_of_month.wday
    empty_days = Array.new(begining_of_the_week > 0 ? begining_of_the_week-1 : 0) { nil }
    
    days_in_the_month = current_datetime.end_of_month.day
    calendar_days = Array.new(days_in_the_month) {|i| i+1 }
    
    @date = {
      year: current_datetime.year,
      month: current_datetime.strftime("%B"),
      current_date: current_datetime,
      days: empty_days + calendar_days,
      is_current_month: DateTime.now >= beginning_of_month &&  DateTime.now <= end_of_month
    }
  end
  
  # POST /events
  def create
    event = Event.new(event_params.except(:date))
    event.user = current_user
    event.start_date = get_datetime(event_params[:date], event_params[:start_date])
    event.end_date = get_datetime(event_params[:date], event_params[:end_date])
    
    if event.save
      redirect_to events_path
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def get_event
      @event = Event.find(params[:id])
    end
    
    def get_datetime(date, time)
      return nil if date.blank? || time.blank?
      
      begin
        Time.parse("#{date} #{time}").getutc
      rescue
        nil
      end
    end
    
    def event_params
      params.require(:event).permit(:title, :description, :date, :start_date, :end_date)
    end
end
