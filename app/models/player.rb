class Player < ActiveRecord::Base
  has_many :games
  

  def rating
    self[:rating].to_i
  end

  def rating=(value)
    self[:rating] = value.to_s
  end
end
