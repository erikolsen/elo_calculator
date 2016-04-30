class Tournament < ActiveRecord::Base
  has_many :entries
  has_many :entries, through: :players
end
