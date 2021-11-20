ActiveAdmin.register NewsCategory, as: 'Group' do
  
  # Actions
  actions :all, except: [:edit, :update]
  
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
      if NewsCategory::DEFAULT_CATEGORIES.append('news').include?(news_category.title)
        'default'
      else
        news_category.created_at
      end
    end
    
    column :links do |news_category|
      links = ''.html_safe
      links += link_to I18n.t('active_admin.view'), admin_group_path(news_category), class: "member_link view_link"
      if NewsCategory::DEFAULT_CATEGORIES.append('news').exclude?(news_category.title)
        links += link_to I18n.t('active_admin.delete'), admin_group_path(news_category), method: :delete, confirm: I18n.t('active_admin.delete_confirmation'), class: "member_link delete_link"
      end
      
      links
    end
  end
  
  form do |f|
    f.inputs do
      f.input :image, as: :file, input_html: { direct_upload: true }
      f.input :title
    end
    f.actions
  end
end
