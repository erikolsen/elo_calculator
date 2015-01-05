  class RatingUpdater
    attr_reader :winner, :loser
    K_FACTOR = 50.00

    def initialize(winner, loser)
      @winner = winner
      @loser = loser
    end

    def difference_in_ratings
      (winner.rating - loser.rating)
    end

    def the_pow
      (difference_in_ratings.to_f / 400.00).round(2)
    end

    def the_exponenet
      (10.00**the_pow.to_f)
    end

    def the_denominator
      (the_exponenet.to_f + 1.00)
    end

    def loser_percent
      (1.00 / the_denominator.to_f)
    end

    def winner_percent
      1.00 - loser_percent.to_f
    end

    def change_in_rating
      (K_FACTOR * (1.00 - winner_percent.to_f)).ceil
    end
  end
