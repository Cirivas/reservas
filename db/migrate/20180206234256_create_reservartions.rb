class CreateReservartions < ActiveRecord::Migration[5.1]
  def change
    create_table :reservations do |t|
      t.timestamp :start_time, null: false
      t.timestamp :finish_time, null: false
      t.references :user, references: :user, null: false
      t.references :aeroplane, foreign_key: true, null: false
      t.references :instructor, references: :user
      t.string :flight_type, null: false
      t.text :route, default: ""

      t.timestamps
    end
  end
end
