#  expected_score_for_a = 1/(1 + pow(10, (score_for_b - score_for_a)/400))
  class RatingUpdater
    attr_reader :winner_rating, :loser_rating
    K_FACTOR = 50.00

    def initialize(winner_rating, loser_rating)
      @winner_rating = winner_rating
      @loser_rating = loser_rating
    end

    def difference_in_ratings
      (loser_rating- winner_rating)
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
