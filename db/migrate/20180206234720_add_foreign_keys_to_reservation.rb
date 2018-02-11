class AddForeignKeysToReservation < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :reservations, :user, column: :user_id
    add_foreign_key :reservations, :user, column: :instructor_id
  end
end
