class Api::V1::NotificationsController < Api::V1::ApiController
  
  # GET /api/v1/notifications
  def index
    notifications = NewsCategory.order(id: :desc).page(params[:page]).per(30)
    notifications_json = ActiveModel::Serializer::CollectionSerializer.new(notifications, serializer: NotificationSerializer).as_json
    render json: { notifications: notifications_json }, status: :ok
  end
  
  # PUT/PATCH /api/v1/notifications/:id
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
