class Api::V1::LanguagesController < Api::V1::ApiController
  
  # GET /api/v1/languages
  def index
    languages_json = ActiveModel::Serializer::CollectionSerializer.new(Language.all, serializer: LanguageSerializer).as_json
    render json: { languages: languages_json }, status: :ok
  end
end
