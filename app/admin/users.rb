ActiveAdmin.register User do
  
  # Actions
  actions :index, :show, :edit, :update
  
  # Filters
  filter :email
  
  # Params
  permit_params :birthday, :blocked_comment, :email, :first_name, :last_name, :phone_number
  
  # Controllers
  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :birthday
    column :blocked_at
    actions
  end
  
  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :birthday
      row :blocked_at
      row :blocked_comment
      row :created_at
      row :updated_at
    end
    
    panel 'Devices' do
      table_for user.devices.order('name asc') do
        column :id
        column :name
        column :operational_system
        column :created_at
      end
    end
  end
  
  form do |f|
    f.inputs do
      f.input :blocked_comment, label: 'Type reason to block this User'
    end
    f.actions
  end
end
