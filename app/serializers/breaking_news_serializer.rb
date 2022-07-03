# == Schema Information
#
# Table name: breaking_news
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#
class BreakingNewsSerializer < ActiveModel::Serializer
   attribute :title
   def title
     object.post&.title
   end
   
   attribute :post_id
 end
