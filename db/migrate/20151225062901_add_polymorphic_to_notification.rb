class AddPolymorphicToNotification < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :notifiable_id, :integer
    add_column :notifications, :notifiable_type, :string
    add_index :notifications, [:notifiable_id, :notifiable_type]
  end
end
