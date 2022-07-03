class DownloadAppsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  # GET /homepage
  def index
  end
end
