class StreamInfoSerializer < ActiveModel::Serializer
  attribute :lits_count
  attribute :views_count
  attribute :stream_comments_count
  
  attribute :formated_lits_count
  def formated_lits_count
    ActionController::Base.helpers.number_to_human(object.lits_count, units: { thousand: 'T', million: 'M', billion: 'B', trillion: 'T', quadrillion: 'Q' })
  end
  
  attribute :formated_views_count
  def formated_views_count
    ActionController::Base.helpers.number_to_human(object.views_count, units: { thousand: 'T', million: 'M', billion: 'B', trillion: 'T', quadrillion: 'Q' })
  end
  
  attribute :formated_stream_comments_count
  def formated_stream_comments_count
    ActionController::Base.helpers.number_to_human(object.stream_comments_count, units: { thousand: 'T', million: 'M', billion: 'B', trillion: 'T', quadrillion: 'Q' })
  end
end
