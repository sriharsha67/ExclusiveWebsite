class RenameUsersToTickets < ActiveRecord::Migration
  def change
    rename_table :users, :tickets
  end
end
