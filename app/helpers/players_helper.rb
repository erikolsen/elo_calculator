module PlayersHelper

  def player_and_opponent_link(player, opponent)
    games_played = Game.for_players(player, opponent)
    player_wins = games_played.where(winner_id: player.id).count
    loser_wins = games_played.where(winner_id: opponent.id).count
    percent = (player_wins.to_f / games_played.count.to_f).round(2) * 100.0
    link_title = "#{player.name} vs. #{opponent.name}"
    link_to matchups_path(matchup: { primary_id: player.id, secondary_id: opponent.id}), method: 'post', class: 'button expand rematchLink' do
      link = content_tag(:span, number_to_percentage(percent, precision: 0), class: 'left')
      link += content_tag(:span, link_title, class: 'center')
      link += content_tag(:span, "#{player_wins} / #{loser_wins}", class: 'right')
      link
    end
  end

  def top_ten_players
    Player.all.sort_by(&:rating).reverse.first(10)
  end

  def last_game
    Game.last
  end

  def winner_id
    last_game.winner_id || 1
  end

  def loser_id
    last_game.loser_id || 1
  end

  def all_players_exclude(players)
    Player.by_name - players
  end

end
