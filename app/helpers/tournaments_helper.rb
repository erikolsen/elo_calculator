module TournamentsHelper
  def primary_foo(match)
    return winner_of_primary(match) if winner_of_primary(match).present?
    return link_for_primary(match) if !match.primary
    Player.find(match.primary).name
  end

  def secondary_foo(match)
    return winner_of_secondary(match) if winner_of_secondary(match).present?
    return "BYE" if match.secondary == "BYE"
    return link_for_secondary(match) if !match.secondary
    Player.find(match.secondary).name
  end

  def link_for_primary(match)
    last = match.tournament.bracket_matchups.where(tournament_sequence: match.primary_parent).first
    p = Player.where(id: last.primary).first&.name
    s = Player.where(id: last.secondary).first&.name
    "#{p} vs. #{s}" if p
  end

  def link_for_secondary(match)
    last = match.tournament.bracket_matchups.where(tournament_sequence: match.secondary_parent).first
    p = Player.where(id: last.primary).first&.name
    s = Player.where(id: last.secondary).first&.name
    "#{p} vs. #{s}" if s
  end

  def winner_of_primary(match)
    winner = match.tournament.bracket_matchups.where(tournament_sequence: match.primary_parent).first&.winner
    Player.find(winner).name if winner
  end

  def winner_of_secondary(match)
    winner = match.tournament.bracket_matchups.where(tournament_sequence: match.secondary_parent).first&.winner
    Player.find(winner).name if winner
  end
end
