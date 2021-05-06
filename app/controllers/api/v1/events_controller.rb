class Api::V1::EventsController < Api::V1::ApiController
  
  # GET /api/v1/events
  def index
    begin
      current_datetime = Time.parse(params[:date])
    rescue
      current_datetime = DateTime.current
    end
    
    events_json = ActiveModel::Serializer::CollectionSerializer.new(current_user.events.where('start_date >= ? AND start_date <= ?', current_datetime.beginning_of_month, current_datetime.end_of_month).order(start_date: :asc), serializer: EventSerializer).as_json
    render json: { events: events_json }, status: :ok
  end
  
  # POST /api/v1/events
  def create
    event = Event.new(event_params.except(:date))
    event.user = current_user
    event.start_date = get_datetime(event_params[:date], event_params[:start_date])
    event.end_date = get_datetime(event_params[:date], event_params[:end_date])
    
    if event.save
      event_json = EventSerializer.new(event).as_json
      render json: { event: event_json }, status: :ok
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # PUT/PATCH /api/v1/events/:id
  def update
    event = current_user.events.find(params[:id])
    event.start_date = get_datetime(event_params[:date], event_params[:start_date])
    event.end_date = get_datetime(event_params[:date], event_params[:end_date])
    
    if event.update(event_params.except(:date, :start_date, :end_date))
      event_json = EventSerializer.new(event).as_json
      render json: { event: event_json }, status: :ok
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/events/:id
  def destroy
    event = current_user.events.find(params[:id])
    event.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    def event_params
      params.require(:event).permit(:date, :description, :end_date, :start_date, :title)
    end
    
    def get_datetime(date, time)
      return nil if date.blank? || time.blank?
      
      begin
        Time.parse("#{date} #{time}").getutc
      rescue
        nil
      end
    end
end
