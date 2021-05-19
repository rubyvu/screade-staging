class NotificationsController < ApplicationController
  
  # GET /notifications
  def index
    @notifications = NewsCategory.where(is_viewed: false).order(id: :desc)
  end
  
  # PUT/PATCH /notifications/:id
  def update
    notification = Notification.find(params[:id])
    if notification.update(notification_params)
      notification_json = NotificationSerializer.new(notification).as_json
      render json: { notification: notification_json }, status: :ok
    else
      render json: { errors: notification.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def notification_params
      params.require(:notification).permit(:is_viewed)
    end
end
