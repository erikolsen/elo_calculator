module TournamentsHelper
  def single_elim_winner(tournament)
    last = tournament.winners_bracket.last
    last.winner if last.winner
  end

  def single_elim_runner_up(tournament)
    last = tournament.winners_bracket.last
    last.loser if last.loser
  end

  def show_primary(bracket)
    return bracket.winner.name if bracket.is_bye
    bracket.matchup.primary_id ? player_for(bracket.matchup.primary_id) : link_for_primary(bracket)
  end

  def show_secondary(bracket)
    return "BYE" if bracket.is_bye
    bracket.matchup.secondary_id ? player_for(bracket.matchup.secondary_id) : link_for_secondary(bracket)
  end

  def link_for_primary(bracket)
    bracket_child = bracket.siblings.where(winner_child: bracket.tournament_sequence).first
    link_for_bracket_child bracket_child
  end

  def link_for_secondary(bracket)
    bracket_child = bracket.siblings.where(winner_child: bracket.tournament_sequence).last
    link_for_bracket_child bracket_child
  end

  def final_round_link(tournament)
    last = tournament.brackets.where(bracket_type: 'winners').last
    last.winner ? last.winner.name : link_for_bracket_child(last)
  end

  def link_for_bracket_child(bracket)
    primary = bracket.matchup.primary_id
    secondary = bracket.matchup.secondary_id
    return nil unless primary && secondary
    link_to "#{player_for primary} vs. #{player_for secondary}", edit_matchup_path(bracket.matchup)
  end

  def player_for(id)
    Player.find_by(id: id)&.name
  end
end
