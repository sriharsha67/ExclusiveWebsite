class HomeController < ApplicationController
  def welcome
    if User.any?
      token_time = User.first.created_at + User.count.minutes
      @seconds_left = (token_time - Time.now).to_i
    else
      @seconds_left = 0
    end
    @user = User.new
  end

  def waiting
    
  end
end