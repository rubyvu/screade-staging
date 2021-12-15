class Api::V1::ReportsController < Api::V1::ApiController
  
  # POST /api/v1/reports
  def create
    report = Report.new(report_params)
    report.reporter = current_user
    
    if report.save
      report_json = ReportSerializer.new(report).as_json
      render json: { report: report_json }, status: :created
    else
      render json: { errors: report.errors }, status: :unprocessable_entity
    end
  end
  
  private
    def report_params
      params.require(:report).permit(:details, :reported_user_id)
    end
end
