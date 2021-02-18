ActiveAdmin.register BreakingNews do
  
  # Actions
  actions :all
  
  # Filters
  filter :country
  filter :is_active
  filter :title
  
  # Params
  permit_params :country_id, :is_active, :title
  
  form do |f|
    f.inputs do
      f.input :country, as: :select, collection: Country.order(title: :asc).map { |country| [country.title, country.id] }
      f.input :title
      f.input :is_active
    end
    f.actions
  end
  
end
