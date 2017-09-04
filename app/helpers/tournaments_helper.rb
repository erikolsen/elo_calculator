module TournamentsHelper
  def show_primary(match)
    match.primary ? player_for(match.primary) : link_for_primary(match)
  end

  def show_secondary(match)
    return "BYE" if match.secondary == 0
    match.secondary ? player_for(match.secondary) : link_for_secondary(match)
  end

  def link_for_primary(match)
    bracket_matchup = match.siblings.where(winner_child: match.tournament_sequence).first
    link_for_bracket_matchup bracket_matchup
  end

  def link_for_secondary(match)
    bracket_matchup = match.siblings.where(winner_child: match.tournament_sequence).last
    link_for_bracket_matchup bracket_matchup
  end

  def final_round_link(tournament)
    last = tournament.bracket_matchups.last
    last.winner ? last.winner.name : link_for_bracket_matchup(last)
  end

  def link_for_bracket_matchup(bracket_matchup)
    link_to "#{player_for bracket_matchup.primary} vs. #{player_for bracket_matchup.secondary}", edit_matchup_path(bracket_matchup.matchup)
  end

  def player_for(id)
    Player.find_by(id: id)&.name
  end
end
