class AddForeignKeysToReservation < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :reservations, :users, column: :user_id
    add_foreign_key :reservations, :users, column: :instructor_id
  end
end
