class ChangeNotification < ActiveRecord::Migration[5.0]
  def change
    rename_column :notifications, :sloved, :solved
  end
end
