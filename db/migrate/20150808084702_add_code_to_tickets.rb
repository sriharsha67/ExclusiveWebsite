class AddCodeToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :code, :string
  end
end
