class AddClaimedToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :claimed, :boolean, default: false
  end
end
