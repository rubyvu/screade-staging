ActiveAdmin.register Topic do
  
  # Actions
  actions :all
  
  # Filters
  filter :title
  
  # Params
  permit_params :is_approved, :parent_id, :parent_type, :title
  
  # DELETE /admin/topics/:id/unlink
  member_action :unlink, method: :delete do
    topic = Topic.find(params[:id])
    news_article = topic.news_articles.find(params[:news_article_id])
    topic.news_articles.delete(news_article)
    redirect_to admin_topic_path(topic), notice: "NewsArticle successfully removed!"
  end
  
  # Controllers
  index do
    column :id
    column 'Full Path' do |topic|
      if topic.class.name == 'NewsCategory'
        topic.title.capitalize
      else
        case topic.nesting_position
        when 0
          "#{topic.parent.title.capitalize}-#{topic.title.capitalize}"
        when 1
          "#{topic.parent.parent.title.capitalize}-#{topic.parent.title.capitalize}-#{topic.title.capitalize}"
        when 2
          "#{topic.parent.parent.parent.title.capitalize}-#{topic.parent.parent.title.capitalize}-#{topic.parent.title.capitalize}-#{topic.title.capitalize}"
        end
      end
    end
    
    column :title
    column :parent_id do |topic|
      if topic.parent.class.name == 'NewsCategory'
        link_to topic.parent.title.capitalize, admin_group_path(topic.parent)
      else
        link_to topic.parent.title.capitalize, admin_topic_path(topic.parent)
      end
    end
    
    column :is_approved
    actions
  end
  
  show do
    attributes_table do
      row :id
      row :title
      row 'Parrent' do |topic|
        parent = topic.parent
        if parent.present?
          case parent.class.name
          when 'NewsCategory'
            link_to(parent.title, admin_topic_path(parent))
          when 'Topic'
            link_to(parent.title, admin_topic_path(parent))
          end
        else
          '-'
        end
      end
      row :created_at
      row :updated_at
    end
    
    panel 'Topic Articles' do
      table_for topic.news_articles.order(id: :desc) do
        column 'Id' do |news_article|
          news_article.id
        end
        
        column 'Title' do |news_article|
          news_article.title
        end
        
        column 'Created At' do |news_article|
          news_article.created_at
        end
        
        column 'Actions' do |news_article|
          span link_to 'Unlink', unlink_admin_topic_path(id: topic.id, news_article_id: news_article.id), method: :delete, data: { confirm: 'Are you really want to unlink this NewsArticle from Topic?' }
        end
      end
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
      f.input :title
      f.input :parent_id, label: 'Parent', as: :select, collection: (NewsCategory.order(title: :desc) + Topic.where(is_approved: true).where.not(nesting_position: 2).order(nesting_position: :desc, title: :asc)).map { |t| [parent_title(t), t.id, {"data-type" => t.class.name}]} if object.new_record?
      f.input :parent_type, as: :hidden
      f.input :is_approved
    end
    f.actions
  end
end
