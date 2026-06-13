class RemoveGlobalUniqueIndexFromBlueprintsSlug < ActiveRecord::Migration[8.1]
  def change
    remove_index :blueprints, :slug, if_exists: true
    add_index :blueprints, :slug, if_not_exists: true
  end
end
