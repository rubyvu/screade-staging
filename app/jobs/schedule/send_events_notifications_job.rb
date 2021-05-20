class Schedule::SendEventsNotificationsJob < ApplicationJob
  
  def run
    puts "=== run SendEventsNotificationsJob === #{DateTime.current}"
    
    Event.where('start_date >= ? AND start_date <= ?', DateTime.current, DateTime.current + 30.minutes).each do |event|
      CreateNewNotificationsJob.perform_later(event.id, 'Event') if Notification.find_by(source: event).blank?
    end
  end
end
