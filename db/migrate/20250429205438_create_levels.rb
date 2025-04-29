class CreateLevels < ActiveRecord::Migration[8.0]
  def change
    create_table :levels do |t|
      t.references :member, null: false, foreign_key: true
      t.string :level_type, null: false, default: "continuous_glucose_monitoring"
      t.integer :value, null: false
      t.datetime :tested_at, null: false
      t.string :tz_offset, null: false, default: "-07:00"
      t.string :unit, null: false, default: "mg/dL"

      t.timestamps
    end
  end
end
