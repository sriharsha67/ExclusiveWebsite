# == Schema Information
#
# Table name: current_tickets
#
#  id           :integer          not null, primary key
#  ticket_id    :integer
#  activated_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CurrentTicket < ActiveRecord::Base
  # This is the number of seconds between two tickets activations
  TICKET_INTERVAL = 60

  belongs_to :ticket

  def self.fetch
    self.first
  end

  def self.seconds_left
    if self.fetch.ticket
      seconds_since_activation = Time.now - self.fetch.activated_at
      return TICKET_INTERVAL - seconds_since_activation
    else
      return 0
    end
  end

  def set_ticket(tkt)
    self.ticket = tkt
    self.activated_at = Time.now
    self.save!
  end
end
