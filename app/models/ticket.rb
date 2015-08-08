# == Schema Information
#
# Table name: tickets
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ticket_no  :integer
#  waiting    :boolean          default(TRUE)
#

class Ticket < ActiveRecord::Base
  scope :waiting, -> {where(waiting: true)}

  validates :name, presence: true
  validates :email, presence: true, format: {with: /\A[a-zA-Z][\w\.\+-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]\z/}
  validates :code, presence: true

  before_validation :set_token_details
  after_create :set_current_if_none_current

  def activate!
    CurrentTicket.fetch.set_ticket(self)
  end

  def claim!
    self.claimed = true
    self.waiting = false
    self.save!
  end

  def mark_waiting!(wting = true)
    self.update_attribute(:waiting, wting)
  end

private
  def set_token_details
    return unless self.new_record?
    self.ticket_no = Ticket.count + 1
    self.code = RandomPasswordGenerator.generate(8, skip_symbols: true)
  end

  def set_current_if_none_current
    return if CurrentTicket.fetch.ticket
    self.activate!
  end
end