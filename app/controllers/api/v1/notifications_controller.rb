class Api::V1::NotificationsController < Api::V1::ApiController
  
  # GET /api/v1/notifications
  def index
    notifications = Notification.where(recipient: current_user, is_viewed: false).order(created_at: :desc).page(params[:page]).per(30)
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
  
  # PUT /api/v1/notifications/view_all
  def view_all
    notifications = Notification.where(recipient: current_user)
    
    notifications.update_all(is_viewed: true)
    render json: { success: true }, status: :ok
  end
  
  private
    def notification_params
      params.require(:notification).permit(:is_viewed)
    end
end
