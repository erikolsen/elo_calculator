module TournamentsHelper
  def show_primary(match)
    return link_for_primary(match) if !match.primary
    Player.find(match.primary).name
  end

  def show_secondary(match)
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

  def final_round_link(tournament)
    last = tournament.bracket_matchups.last
    return Player.where(id: last.winner).first.name if last.winner
    p = Player.where(id: last.primary).first&.name
    s = Player.where(id: last.secondary).first&.name
    link_to "#{p} vs. #{s}", edit_matchup_path(last.matchup)
  end
end
