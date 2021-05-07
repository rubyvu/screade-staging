class ChangePostGroupsAssociationToPolymorphic < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :news_category_id, :integer
    remove_column :posts, :topic_id, :integer
    add_column :posts, :source_id, :integer, null: false
    add_column :posts, :source_type, :string, null: false
  end
end
