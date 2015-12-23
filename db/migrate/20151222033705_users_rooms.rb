class UsersRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :users_rooms, id: false do |t|
      t.belongs_to :user
      t.belongs_to :room
    end
  end
end
