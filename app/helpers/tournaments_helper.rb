module TournamentsHelper
  def primary_foo(match)
    #return winner_of_primary_parent(match) if winner_of_primary_parent(match).present?
    return link_for_primary(match) if !match.primary
    Player.find(match.primary).name
  end

  def secondary_foo(match)
    #return winner_of_secondary_parent(match) if winner_of_secondary_parent(match).present?
    return "BYE" if match.secondary == 0
    return link_for_secondary(match) if !match.secondary
    Player.find(match.secondary).name
  end

  def player_for(id)
    Player.where(id: id).first&.name
  end

  def link_for_primary(match)
    last = match.tournament.bracket_matchups.where(winner_child: match.tournament_sequence).first
    p = Player.where(id: last.primary).first&.name
    s = Player.where(id: last.secondary).first&.name
    link_to "#{p} vs. #{s}", edit_matchup_path(last.matchup)
  end

  def link_for_secondary(match)
    last = match.tournament.bracket_matchups.where(winner_child: match.tournament_sequence).last
    p = Player.where(id: last.primary).first&.name
    s = Player.where(id: last.secondary).first&.name
    link_to "#{p} vs. #{s}", edit_matchup_path(last.matchup)
  end

  def winner_of_primary_parent(match)
    winner = match.tournament.bracket_matchups.where(tournament_sequence: match.primary_parent).first&.winner
    Player.find(winner).name if winner
  end

  def winner_of_secondary_parent(match)
    winner = match.tournament.bracket_matchups.where(tournament_sequence: match.secondary_parent).first&.winner
    Player.find(winner).name if winner
  end
end
