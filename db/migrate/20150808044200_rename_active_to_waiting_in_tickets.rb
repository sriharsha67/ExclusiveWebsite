class RenameActiveToWaitingInTickets < ActiveRecord::Migration
  def change
    rename_column :tickets, :active, :waiting
  end
end
