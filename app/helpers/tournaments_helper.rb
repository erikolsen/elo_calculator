module TournamentsHelper
  def single_elim_winner(tournament)
    last = tournament.winners_bracket.last
    last.winner.name if last.winner
  end

  def single_elim_runner_up(tournament)
    last = tournament.winners_bracket.last
    last.loser.name if last.loser
  end

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
    last = tournament.bracket_matchups.where(bracket_type: 'winners').last
    last.winner ? last.winner.name : link_for_bracket_matchup(last)
  end

  def link_for_bracket_matchup(bracket_matchup)
    primary = bracket_matchup.primary
    secondary = bracket_matchup.secondary
    return nil unless primary && secondary
    link_to "#{player_for primary} vs. #{player_for secondary}", edit_matchup_path(bracket_matchup.matchup)
  end

  def player_for(id)
    Player.find_by(id: id)&.name
  end
end
