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

require 'test_helper'

class CurrentTicketTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
