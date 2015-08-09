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
#  code       :string
#  claimed    :boolean
#

class Ticket < ActiveRecord::Base
  scope :waiting, -> {where(waiting: true)}

  validates :name, presence: true
  validates :email, presence: true, format: {with: /\A[a-zA-Z][\w\.\+-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]\z/}
  validates :code, presence: true

  before_validation :set_token_details
  after_create :set_current_if_none_current, :publish_new_ticket_no
  after_update :publish_waiting_count

  def activate!
    CurrentTicket.fetch.set_ticket(self)
  end

  def claim!
    self.claimed = true
    self.waiting = false
    self.save!
  end

  def mark_waiting!(wting = true)
    self.update_attributes(waiting: wting)
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

  def pubnub_service
    @pubnub ||= Pubnub.new(
      subscribe_key: ENV['PUBNUB_SUBSCRIBE_KEY'],
      publish_key: ENV['PUBNUB_PUBLISH_KEY']
    )
  end

  def publish_to_pubnub(msg, channel)
    callback = lambda { |envelope| puts envelope.message }
    pubnub_service.publish(message: msg, channel: channel, callback: callback)
  end

  def publish_new_ticket_no
    publish_to_pubnub({
        next_ticket_no: self.ticket_no + 1,
        waiting_count: Ticket.waiting.count,
        serving_name: CurrentTicket.fetch.ticket.name,
        serving_no: CurrentTicket.fetch.ticket.ticket_no
      }, "queue"
    )
  end

  def publish_waiting_count
    return if self.waiting == self.waiting_was
    publish_to_pubnub({
      waiting_count: Ticket.waiting.count,
      serving_name: CurrentTicket.fetch.ticket.name,
      serving_no: CurrentTicket.fetch.ticket.ticket_no,
      recently_changed_no: self.ticket_no,
      waiting: self.waiting
      }, "queue"
    )
  end
end
