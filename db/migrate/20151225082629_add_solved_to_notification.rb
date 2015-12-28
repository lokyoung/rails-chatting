class AddSolvedToNotification < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :sloved, :boolean
  end
end
