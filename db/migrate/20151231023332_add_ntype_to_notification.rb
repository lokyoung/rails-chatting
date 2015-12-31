class AddNtypeToNotification < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :n_type, :integer
  end
end
