ActiveAdmin.register NewsCategory, as: 'Group' do
  
  # Actions
  actions :all, except: [:new, :create, :destroy]
  
  # Filters
  filter :title
  
  # Params
  permit_params :image, :title
  
  # Controllers
  index do
    column :id
    column :image do |news_category|
      image_tag news_category.image_url if news_category.image_url.present?
    end
    column :title
    column :created_at do |news_category|
      if NewsCategory::DEFAULT_CATEGORIES.include?(news_category.title)
        'default'
      else
        news_category.created_at
      end
    end
    
    actions
  end
  
  form do |f|
    f.inputs do
      f.input :image, as: :file, input_html: { direct_upload: true }
    end
    f.actions
  end
end
