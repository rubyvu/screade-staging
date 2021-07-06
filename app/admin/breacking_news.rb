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
  
  form do |f|
    f.inputs do
      f.input :post_id, label: 'Post', as: :select, collection: Post.where(user: User.find_by(username: 'admin.screade')).order(title: :desc)
    end
    
    f.actions
  end
  
end
