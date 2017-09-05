module SingleElimination
  def self.build_matchups_for(tournament)
    gen = BracketGenerator.new(tournament.players)
    gen.first_round.each do |match|
      primary = match.first
      secondary = match.last
      tournament.bracket_matchups.create primary: primary,
                                         secondary: secondary,
                                         matchup_id: matchup_for(tournament, primary, secondary),
                                         winner_id: (match.first if match.include? 0),
                                         tournament_sequence: tournament.bracket_matchups.count + 1
    end

    gen.remaining_matches.times do
      tournament.bracket_matchups.create matchup_id: tournament.matchups.create.id,
                                         tournament_sequence: tournament.bracket_matchups.count + 1
    end

    counter = gen.first_round.count
    tournament.bracket_matchups.each_slice(2) do |matches|
      break if matches.one?
      counter +=1
      matches.first.update_column(:winner_child, counter)
      matches.last.update_column(:winner_child, counter)
    end

    tournament.bracket_matchups.each(&:update_children!)
  end

  def self.matchup_for(tournament, primary, secondary)
    return nil if [primary, secondary].include? 0
    matchup = tournament.matchups.create primary_id: primary, secondary_id: secondary
    return matchup.id if matchup
  end

  def self.try_winner(seq, tournament)
    tournament.bracket_matchups.where(tournament_sequence: seq).first&.winner_id
  end
end

class BracketGenerator
  attr_reader :players, :count
  def initialize(players)
    raise 'No Players' if players.nil?
    @players = players.sort_by(&:rating).reverse.map(&:id)
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

