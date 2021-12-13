# == Schema Information
#
# Table name: user_security_questions
#
#  id                  :bigint           not null, primary key
#  question_identifier :string           not null
#  title               :string           not null
#
# Indexes
#
#  index_user_security_questions_on_question_identifier  (question_identifier) UNIQUE
#
class UserSecurityQuestionSerializer < ActiveModel::Serializer
  attribute :title
  attribute :question_identifier
end
