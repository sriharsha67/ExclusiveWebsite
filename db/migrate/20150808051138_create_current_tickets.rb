class CreateCurrentTickets < ActiveRecord::Migration
  def change
    create_table :current_tickets do |t|
      t.references :ticket, index: true, foreign_key: true
      t.datetime :activated_at
    end
  end
end
