class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :recipient_id
      t.integer :sender_id
      t.text :text

      t.timestamps null: false
    end

    add_index :messages, ["recipient_id", "sender_id"]
  end
end
