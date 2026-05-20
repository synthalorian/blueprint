class CreateServices < ActiveRecord::Migration[8.1]
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.boolean :enabled, default: true, null: false
      t.references :blueprint, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :services, [ :blueprint_id, :name ], unique: true
  end
end
