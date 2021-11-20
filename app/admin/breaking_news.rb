ActiveAdmin.register BreakingNews do
  
  # Actions
  actions :all, except: [:new, :create, :destroy]
  
  # Params
  permit_params :post_id
  
  index do
    column :post
    column :updated_at
    actions
  end
  
  show do
    attributes_table do
      row :id
      row :post
      row :created_at
      row :updated_at
    end
    
    panel 'Admin Posts' do
      table_for Post.where(user: User.find_by(username: 'admin.screade')).order(updated_at: :asc) do
        column 'Id' do |post|
          post.id
        end
        
        column 'Id' do |post|
          if post.image_url.present?
            image_tag post.image_url, class: 'admin-index-image'
          else
            image_pack_tag('media/images/placeholders/placeholder-news.png', class: 'admin-index-image')
          end
        end
        
        column 'Title' do |post|
          link_to post.title, edit_admin_post_path(post)
        end
        
        column 'Description' do |post|
          post.description
        end
        
        column 'Is Approved' do |post|
          post.is_approved
        end
        
        column 'Created At' do |post|
          post.created_at
        end
        column 'Updated At' do |post|
          post.updated_at
        end
      end
    end
  end
  
  form do |f|
    f.inputs do
      f.input :post_id, label: 'Post', as: :select, collection: Post.where(user: User.find_by(username: 'admin.screade')).order(title: :desc)
    end
    
    f.actions
  end
end
