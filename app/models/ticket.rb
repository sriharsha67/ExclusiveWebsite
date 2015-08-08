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

  def activate!
    CurrentTicket.fetch.set_ticket(self)
  end

private
  def set_token_details
    return unless self.new_record?
    self.ticket_no = Ticket.count + 1
    self.code = RandomPasswordGenerator.generate(8, skip_symbols: true)
  end
end
