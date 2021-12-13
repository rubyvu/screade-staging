# == Schema Information
#
# Table name: contact_us_requests
#
#  id          :bigint           not null, primary key
#  email       :string           not null
#  first_name  :string           not null
#  last_name   :string           not null
#  message     :text             not null
#  resolved_at :datetime
#  resolved_by :string
#  subject     :string           not null
#  username    :string           not null
#  version     :string           default("0")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ContactUsRequestSerializer < ActiveModel::Serializer
  attribute :email
  attribute :first_name
  attribute :last_name
  attribute :message
  attribute :subject
  attribute :username
end
