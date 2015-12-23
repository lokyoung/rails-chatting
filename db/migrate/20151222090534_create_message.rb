class CreateMessage < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :user, index: true, foreign_key: true
      t.references :room, index: true, foreign_key: true
    end
  end
end
