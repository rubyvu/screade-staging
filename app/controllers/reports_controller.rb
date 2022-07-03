class ReportsController < ApplicationController
  
  # POST /reports
  def create
    report = Report.new(report_params)
    report.reporter = current_user
    
    report.save
    
    redirect_to root_path
  end
  
  private
    def report_params
      params.require(:report).permit(:details, :reported_user_id)
    end
end
