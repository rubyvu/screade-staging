class NotificationsController < ApplicationController
  
  # GET /notifications
  def index
    @notifications = current_user.received_notifications.unviewed.order(id: :desc)
    
    respond_to do |format|
      format.js { render 'index', layout: false }
    end
  end
  
  # PUT/PATCH /notifications/:id
  def update
    notification = Notification.find(params[:id])
    if notification.update(notification_params)
      render json: { success: true }, status: :ok
    else
      render json: { errors: notification.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
    def notification_params
      params.require(:notification).permit(:is_viewed)
    end
end
