class Api::V1::CountriesController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:index]
  
  # GET /api/v1/countries
  def index
    countries_json = ActiveModel::Serializer::CollectionSerializer.new(Country.all, serializer: CountrySerializer).as_json
    render json: { countries: countries_json }, status: :ok
  end
end
