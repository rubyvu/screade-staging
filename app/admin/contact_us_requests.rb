ActiveAdmin.register ContactUsRequest do
  
  # Actions
  actions :all, except: [:new, :create]
  
  # Filters
  filter :email
  filter :username
  
  # Params
  permit_params :resolved_at, :resolved_by
  
  # Controllers
  index do
    column :id
    column :email
    column :first_name
    column :last_name
    column :username
    column :subject
    column :message
    column :version
    column :resolved_at
    column :resolved_by
    actions
  end
  
  form do |f|
    f.inputs do
      f.input :resolved_at, as: :datetime_picker, input_html: { autocomplete: :off }
      f.input :resolved_by
    end
    f.actions
  end
end
