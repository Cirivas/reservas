class CreateAeroplanes < ActiveRecord::Migration[5.1]
  def change
    create_table :aeroplanes do |t|
      t.string :plate, null: false, default: "", limit: 6
      t.string :plane_type, null: false, default: "", limit: 6
      t.string :brand, null: false, default: "", limit: 20
      t.string :next_revision, null: false, default: "", limit: 10
      t.string :flying_time, null: false, default: "", limit: 10
      t.integer :state, null: false, default: ""

      t.timestamps
    end
  end
end
