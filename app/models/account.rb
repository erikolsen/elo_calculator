class Account
  include ActiveModel::Model

  attr_accessor :email, :password, :password_confirmation

  def initialize(player)
    @player = player
  end

end
