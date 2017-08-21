module SingleElimination
  def self.build_matchups_for(tournament)
    gen = BracketGenerator.new(tournament.players)
    gen.first_round.each_with_index do |match, index|
      tournament.bracket_matchups.create primary: match.first,
                                         secondary: match.last,
                                         tournament_sequence: index + 1
    end
    next_rounds = (gen.total_matches - gen.first_round.count) * 2
    (1..next_rounds).each_slice(2).each do |round|
      tournament.bracket_matchups.create primary_parent: round.first,
                                         secondary_parent: round.last,
                                         tournament_sequence: tournament.bracket_matchups.count + 1
    end
  end
end

class BracketGenerator
  attr_reader :players, :count
  def initialize(players)
    raise 'No Players' if players.nil?
    @players = players.sort_by(&:rating).reverse.map(&:id)
  end

  def number_of_rounds
    Math.log(balance_point, 2)
  end

  def total_matches
    balance_point - 1
  end

  def first_round
    @first_round ||= recursive_order_matches(first_byes + first_matches)
  end

  def first_matches
    order_matches players.last(count - byes)
  end

  def order_matches(matches)
    pairings = matches.each_slice(matches.size/2).to_a
    return pairings if pairings.one?
    pairings.first.zip pairings.last.reverse
  end

  def recursive_order_matches(matches)
    return matches.flatten.each_slice(2).to_a if matches.size == 2
    recursive_order_matches order_matches matches
  end

  def first_byes
    players.first(byes).zip Array.new(byes, 'BYE')
  end

  def balance_point
    2**Math.log(count, 2).ceil
    #return count if count.to_s(2).count('1') == 1
    #('1' + ('0' * count.to_s(2).size)).to_i(2)
  end

  def byes
    balance_point - count
  end

  def count
    @count ||= players.count
  end
end

