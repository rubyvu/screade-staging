ActiveAdmin.register Topic do
  
  # Actions
  actions :all
  
  # Filters
  filter :title
  
  # Params
  permit_params :is_approved, :parent_id, :parent_type, :title
  
  # Controllers
  index do
    column :id
    column 'Full Path' do |topic|
      if topic.class.name == 'NewsCategory'
        topic.title.capitalize
      else
        case topic.nesting_position
        when 0
          "#{topic.parent.title.capitalize}-#{topic.title.capitalize}"
        when 1
          "#{topic.parent.parent.title.capitalize}-#{topic.parent.title.capitalize}-#{topic.title.capitalize}"
        when 2
          "#{topic.parent.parent.parent.title.capitalize}-#{topic.parent.parent.title.capitalize}-#{topic.parent.title.capitalize}-#{topic.title.capitalize}"
        end
      end
    end
    
    column :title
    column :parent_id do |topic|
      if topic.parent.class.name == 'NewsCategory'
        link_to topic.parent.title.capitalize, admin_group_path(topic.parent)
      else
        link_to topic.parent.title.capitalize, admin_topic_path(topic.parent)
      end
    end
    
    column :is_approved
    actions
  end
  
  form do |f|
    def parent_title(object)
      if object.class.name == 'NewsCategory'
        object.title.capitalize
      else
        case object.nesting_position
        when 0
          "#{object.parent.title.capitalize}-#{object.title.capitalize}"
        when 1
          "#{object.parent.parent.title.capitalize}-#{object.parent.title.capitalize}-#{object.title.capitalize}"
        when 2
          "#{object.parent.parent.parent.title.capitalize}-#{object.parent.parent.title.capitalize}-#{object.parent.title.capitalize}-#{object.title.capitalize}"
        end
      end
    end
    
    f.inputs do
      f.input :title
      f.input :parent_id, label: 'Parent', as: :select, collection: (NewsCategory.order(title: :desc) + Topic.where(is_approved: true).where.not(nesting_position: 2).order(nesting_position: :desc, title: :asc)).map { |t| [parent_title(t), t.id, {"data-type" => t.class.name}]} if object.new_record?
      f.input :parent_type, as: :hidden
      f.input :is_approved
    end
    f.actions
  end
end
