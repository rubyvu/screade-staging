class Api::V1::PostGroupsController < Api::V1::ApiController
  
  # POST /api/v1/post_groups
  def index
    groups = NewsCategory.all + Topic.where(is_approved: true).or(Topic.where.not(is_approved: true).where(suggester: current_user))
    groups_json = ActiveModel::Serializer::CollectionSerializer.new(groups, serializer: PostGroupSerializer).as_json
    render json: { groups: groups_json }, status: :ok
  end
end
