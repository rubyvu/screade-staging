class LegalDocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:terms_and_services]
  
  def terms_and_services
    render layout: 'legal_document'
  end
end
