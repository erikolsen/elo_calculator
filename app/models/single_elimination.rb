module SingleElimination
  def self.build_matchups_for(tournament)
    gen = BracketGenerator.new(tournament.players)
    counter = gen.first_round.count
    gen.matches.each_with_index do |match, index|
      seq       = index + 1
      primary   = match.first
      secondary = match.last

      counter +=1 if seq.odd?
      winner_child = counter if counter != gen.balance_point

      if match.include?(0)
        winner_id = match.first
      else
        match_id = tournament.matchups.create(primary_id: primary,
                                              secondary_id: secondary).id
      end

      tournament.bracket_matchups.create primary: primary,
                                         secondary: secondary,
                                         matchup_id: match_id,
                                         winner_id: winner_id,
                                         winner_child: winner_child,
                                         tournament_sequence: seq
    end

    tournament.bracket_matchups.each(&:update_children!)
  end
end

class BracketGenerator
  attr_reader :players, :count
  def initialize(players)
    raise 'No Players' if players.nil?
    @players = players.sort_by(&:rating).reverse.map(&:id)
  end

  def matches
    first_round + Array.new(remaining_matches, [nil, nil])
  end

  def remaining_matches
    total_matches - first_round.count
  end

  def first_round
    @first_round ||= recursive_order_matches(first_byes + first_matches)
  end

  def number_of_rounds
    Math.log(balance_point, 2)
  end

  def total_matches
    balance_point - 1
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
    players.first(byes).zip Array.new(byes, 0)
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

