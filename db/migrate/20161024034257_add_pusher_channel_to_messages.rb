class AddPusherChannelToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :pusher_channel, :string
  end
end
