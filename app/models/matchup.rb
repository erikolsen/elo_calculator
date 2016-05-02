class Matchup < ActiveRecord::Base
  belongs_to :tournament
  has_many :players
  has_and_belongs_to_many :games
end
