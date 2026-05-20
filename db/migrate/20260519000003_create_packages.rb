class CreatePackages < ActiveRecord::Migration[8.1]
  def change
    create_table :packages do |t|
      t.string :name, null: false
      t.string :version
      t.string :category, null: false, default: "pacman"
      t.references :blueprint, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :packages, :category
    add_index :packages, [ :blueprint_id, :name, :category ], name: "index_packages_on_blueprint_name_category"
  end
end
