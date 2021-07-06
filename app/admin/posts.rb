ActiveAdmin.register Post do
  
  # Actions
  actions :all
  
  # Params
  permit_params :description, :image, :is_approved, :source_id, :source_type, :title, :user_id
  
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
    # actions
    actions defaults: false do |post|
      links = ''.html_safe
      links += link_to t('active_admin.edit'), edit_admin_post_path(post), class: "member_link view_link"
      links += link_to t('active_admin.delete'), admin_post_path(post), method: :delete, confirm: I18n.t('active_admin.delete_confirmation'), class: "member_link delete_link" if post.user.username == 'dima'
      links
    end
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
      if object.new_record? || object.user.username == 'dima'
        f.input :image
        f.input :title
        f.input :description
        
        f.input :source_id, label: 'Parent', as: :select, collection: (NewsCategory.order(title: :desc) + Topic.where(is_approved: true).order(nesting_position: :desc, title: :asc)).map { |t| [parent_title(t), t.id, {"data-type" => t.class.name}]}
        f.input :source_type, as: :hidden
        
        f.input :user
      else
        f.inputs do
          f.input :is_approved
        end
      end
      f.actions
    end
  end
end
