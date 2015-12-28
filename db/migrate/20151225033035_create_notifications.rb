class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :cotent
      t.integer :recipent_id
      t.integer :actor_id
      t.boolean :unread, default: true

      t.timestamps
    end
  end
end
