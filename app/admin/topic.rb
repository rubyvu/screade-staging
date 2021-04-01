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
    column :title
    column :parent_id do |topic|
      #TO DO: link to
      topic.parent.title
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
      f.input :parent_id, label: 'Parent', as: :select,
        collection: (NewsCategory.order(title: :desc) + Topic.order(title: :desc)).map { |t| [parent_title(t), t.id, {"data-type" => t.class.name}]}
      f.input :parent_type, as: :hidden
      f.input :is_approved
    end
    f.actions
  end
end
