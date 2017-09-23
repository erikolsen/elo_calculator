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
    return bracket.winner.name if bracket.bye
    bracket.primary ? bracket.primary.name : link_for_bracket(bracket.primary_parent)
  end

  def show_secondary(bracket)
    return "BYE" if bracket.bye
    bracket.secondary ? bracket.secondary.name : link_for_bracket(bracket.secondary_parent)
  end

  def final_round_link(tournament)
    last = tournament.winners_bracket.last
    last.winner ? last.winner.name : link_for_bracket(last)
  end

  def link_for_bracket(bracket)
    return nil unless bracket.primary && bracket.secondary
    link_to "#{bracket.primary.name} vs. #{bracket.secondary.name}", edit_matchup_path(bracket.matchup)
  end
end
