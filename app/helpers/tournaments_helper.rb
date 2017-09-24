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
    return link_for(bracket.winner) if bracket.bye
    bracket.primary ? link_for(bracket.primary) : link_for_bracket(bracket.primary_parent)
  end

  def show_secondary(bracket)
    return "BYE" if bracket.bye
    bracket.secondary ? link_for(bracket.secondary) : link_for_bracket(bracket.secondary_parent)
  end

  def final_round_link(tournament)
    last = tournament.winners_bracket.last
    last.winner ? link_for(last.winner) : link_for_bracket(last)
  end

  def link_for_bracket(bracket)
    return nil unless bracket.primary && bracket.secondary
    link_to "#{bracket.primary.name} vs. #{bracket.secondary.name}", edit_matchup_path(bracket.matchup)
  end
end
