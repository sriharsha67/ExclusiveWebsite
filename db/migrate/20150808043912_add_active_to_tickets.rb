class AddActiveToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :active, :boolean, default: true
  end
end
