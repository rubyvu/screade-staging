class ContactUsRequestSerializer < ActiveModel::Serializer
  attribute :email
  attribute :first_name
  attribute :last_name
  attribute :message
  attribute :subject
  attribute :username
end
