require 'rails_helper'

describe 'home page' do
  let!(:player1) { Player.create! name: 'player 1', rating: 500 }
  let!(:player2) { Player.create! name: 'player 2', rating: 600 }

  let!(:game1) { Game.create! winner_id: player1.id, loser_id: player2.id, winner_rating: 400, loser_rating: 500 }
  let!(:game2) { Game.create! winner_id: player2.id, loser_id: player1.id, winner_rating: 500, loser_rating: 400 }

  it 'shows player ratings' do
    visit root_path

    within "#player-#{player1.id}" do
      expect(find('.rank')).to have_content(2)
      expect(find('.name')).to have_content(player1.name)
      expect(find('.rating')).to have_content(player1.rating)
      expect(find('.won-lost')).to have_content("1 / 1")
    end

    within "#player-#{player2.id}" do
      expect(find('.rank')).to have_content(1)
      expect(find('.name')).to have_content(player2.name)
      expect(find('.rating')).to have_content(player2.rating)
      expect(find('.won-lost')).to have_content("1 / 1")
    end
  end
end
