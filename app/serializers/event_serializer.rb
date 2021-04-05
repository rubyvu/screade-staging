class EventSerializer < ActiveModel::Serializer
  attribute :id
  attribute :date
  def date
    object.created_at.strftime('%Y-%m-%d')
  end
  
  attribute :description
  attribute :end_date
  def end_date
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :start_date
  def start_date
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :title
end
