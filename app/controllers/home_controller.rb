class HomeController < ApplicationController
  def welcome
    if current_ticket.ticket
      @waiting_count = Ticket.waiting.count
    end
    @new_ticket = Ticket.new
    @new_ticket.ticket_no = Ticket.count + 1
    @seconds_left = CurrentTicket.seconds_left
  end
end