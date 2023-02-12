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
require 'rails_helper'

RSpec.describe NewsApiLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
