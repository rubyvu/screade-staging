class LegalDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:terms_and_services]
  
  def terms_and_services
    
  end
end
