class EventsController < ApplicationController
  # before_action :get_event
  
  # GET /events/
  def index
    @event = Event.new(user: current_user)
    
    date = params[:date]&.to_date || Date.current
    beginning_of_month = date.beginning_of_month
    end_of_month =  date.end_of_month
    @events = current_user.events.where('date >= ? AND date <= ?', beginning_of_month, end_of_month).order(date: :desc)
    
    begining_of_the_week = date.at_beginning_of_month.wday
    empty_days = Array.new(begining_of_the_week > 0 ? begining_of_the_week-1 : 0) { nil }
    
    days_in_the_month = date.end_of_month.day
    calendar_days = Array.new(days_in_the_month) {|i| i+1 }
    
    @date = {
      year: date.year,
      month: date.strftime("%B"),
      current_date: date,
      days: empty_days + calendar_days,
      is_current_month: Date.current >= beginning_of_month &&  Date.current <= end_of_month
    }
  end
  
  # POST /events
  def create
    event = Event.new(event_params)
    event.user = current_user
    if event.save
      render 'index'
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def get_event
      @event = Event.find(params[:id])
    end
    
    def event_params
      params.require(:event).permit(:title, :description, :date, :start_date, :end_date)
    end
end
