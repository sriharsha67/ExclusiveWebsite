class TicketsController < ApplicationController
  before_action :fetch_ticket, only: [:show, :update]

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.save
      redirect_to ticket_path(@ticket, code: @ticket.code)
    else
      redirect_to root_path, alert: "Please enter your name and email"
    end
  end

  def show
    deny_access! if @ticket.code != params[:code]
    @seconds_left = CurrentTicket.seconds_left
    @ticket.mark_waiting!
    @between_people = Ticket.waiting.where('ticket_no < ?', @ticket.ticket_no).count
  end

  def update
    if params[:closed]
      @ticket.mark_waiting!(false)
    end
  end

private
  def fetch_ticket
    @ticket = Ticket.find(params[:id])
  end
  
  def ticket_params
    params.require(:ticket).permit(:name, :email)
  end
end