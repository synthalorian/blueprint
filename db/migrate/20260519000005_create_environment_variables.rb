class CreateEnvironmentVariables < ActiveRecord::Migration[8.1]
  def change
    create_table :environment_variables do |t|
      t.string :key, null: false
      t.string :value, null: false
      t.references :blueprint, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :environment_variables, [ :blueprint_id, :key ], unique: true
  end
end
