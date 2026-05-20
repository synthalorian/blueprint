class CreateBlueprints < ActiveRecord::Migration[8.1]
  def change
    create_table :blueprints do |t|
      t.string :name, null: false
      t.text :description
      t.text :yaml_content, null: false
      t.string :slug, null: false
      t.boolean :public, default: true, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :blueprints, :slug, unique: true
    add_index :blueprints, :public
    add_index :blueprints, [ :user_id, :slug ], unique: true
  end
end
