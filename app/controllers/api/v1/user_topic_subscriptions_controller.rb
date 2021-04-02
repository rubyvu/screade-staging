class Api::V1::UserTopicSubscriptionsController < Api::V1::ApiController
  before_action :check_user, only: [:create, :destroy]
  
  # POST /api/v1/current_user/:current_user_id/user_topic_subscriptions
  def create
    if user_topic_subscription_params[:source_type] == 'NewsCategory'
      source = NewsCategory.find_by!(user_topic_subscription_params)
    elsif user_topic_subscription_params[:source_type] == 'Topic'
      source = Topic.find_by!(user_topic_subscription_params)
    else
      render json: { errors: ['Source type should be present.'] }, status: :unprocessable_entity
      return
    end
    
    user_topic_subscription = UserTopicSubscription.new(user: current_user)
    user_topic_subscription.source = source
    if user_topic_subscription.save
      render json: { success: true }, status: :ok
    else
      render json: { errors: user_topic_subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/current_user/:current_user_id/user_topic_subscriptions/:id
  def destroy
    user_topic_subscription = current_user.user_topic_subscriptions.find(params[:id])
    user_topic_subscription.delete
    render json: { success: true }, status: :ok
  end
  
  private
    def user_topic_subscription_params
      params.require(:user_topic_subscription).permit(:source_id, :source_type)
    end
    
    def check_user
      user = User.find(params[:current_user_id])
      render status: :not_found if user != current_user
    end
end
