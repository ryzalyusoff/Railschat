class AddExtraOmniauthFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oauth_avatar, :string
    add_column :users, :birthday, :datetime
    add_column :users, :location, :string
    add_column :users, :description, :text
  end
end
