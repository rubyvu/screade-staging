ActiveAdmin.register BreakingNews do
  
  # Actions
  actions :all
  
  # Filters
  filter :is_active
  filter :title
  
  # Params
  permit_params :is_active, :title
  
  form do |f|
    f.inputs do
      f.input :title
      f.input :is_active
    end
    f.actions
  end
  
end
