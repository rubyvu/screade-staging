ActiveAdmin.register Post do
  
  # Actions
  actions :index, :edit, :update
  
  # Params
  permit_params :is_approved
  
  # Filters
  filter :is_approved
  filter :title
  
  index do
    column :id
    column :image do |post|
      if post.image.present?
        image_tag post.image.url, class: 'admin-index-image'
      else
        image_pack_tag('media/images/placeholders/placeholder-news.png', class: 'admin-index-image')
      end
    end
    
    column :title
    column :description
    column :is_approved
    column :user
    column :created_at
    column :updated_at
    actions
  end
  
  form do |f|
    f.inputs do
      f.input :is_approved
    end
    f.actions
  end
end
