class AddTicketNoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ticket_no, :integer
  end
end
