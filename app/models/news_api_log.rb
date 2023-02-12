# == Schema Information
#
# Table name: news_api_logs
#
#  id             :bigint           not null, primary key
#  category       :string
#  country_code   :string
#  request_target :string           not null
#  success        :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class NewsApiLog < ApplicationRecord
end
