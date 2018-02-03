class CreateJoinTableUserAeroplane < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :aeroplanes do |t|
      t.index [:user_id, :aeroplane_id]
      t.index [:aeroplane_id, :user_id]
    end
  end
end
