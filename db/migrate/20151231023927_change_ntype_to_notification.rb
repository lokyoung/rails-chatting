class ChangeNtypeToNotification < ActiveRecord::Migration[5.0]
  def change
    remove_column :notifications, :n_type
    add_column :notifications, :n_type, :integer, default: 0
  end
end
