class CreateDotfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :dotfiles do |t|
      t.string :name, null: false
      t.text :content, null: false
      t.string :target_path, null: false
      t.references :blueprint, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :dotfiles, [ :blueprint_id, :target_path ], unique: true
  end
end
