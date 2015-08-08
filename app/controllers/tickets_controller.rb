class TicketsController < ApplicationController
  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.save
      @ticket.activate! unless Ticket.waiting.any?
      redirect_to ticket_path(@ticket, code: @ticket.code)
    else
      redirect_to root_path, alert: "Please enter your name and email"
    end
  end

  def show
    @ticket = Ticket.find(params[:id])
    deny_access! if @ticket.code != params[:code]
    @seconds_left = CurrentTicket.seconds_left
  end

private
  def ticket_params
    params.require(:ticket).permit(:name, :email)
  end
end