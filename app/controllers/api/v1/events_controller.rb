class Api::V1::EventsController < Api::V1::ApiController
  
  # GET /api/v1/events
  def index
    begin
      date = params[:date].to_date
    rescue
      date = Date.current
    end
    
    events_json = ActiveModel::Serializer::CollectionSerializer.new(current_user.events.where('date >= ? AND date <= ?', date.beginning_of_month, date.end_of_month).order(date: :desc), serializer: EventSerializer).as_json
    render json: { events: events_json }, status: :ok
  end
  
  # POST /api/v1/events
  def create
    event = Event.new(event_params)
    event.user = current_user
    if event.save
      event_json = EventSerializer.new(event).as_json
      render json: { event: event_json }, status: :ok
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # POST /api/v1/events
  def create
    event = Event.new(event_params)
    event.user = current_user
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
    if event.update(event_params)
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
end
