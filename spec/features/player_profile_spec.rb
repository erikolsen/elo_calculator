require 'rails_helper'

describe 'Player Profile' do
  let!(:player1) { Player.create! name: 'Player 1' }
  let!(:player2) { Player.create! name: 'Player 2' }
  let!(:player3) { Player.create! name: 'Player 3' }

  let!(:game1) { Game.create! winner_id: player1.id, loser_id: player2.id, winner_rating: 1000, loser_rating: 1000 }
  let!(:game2) { Game.create! winner_id: player2.id, loser_id: player1.id, winner_rating: 3000, loser_rating: 2000 }
  let!(:game3) { Game.create! winner_id: player3.id, loser_id: player2.id, winner_rating: 5000, loser_rating: 6000 }

  describe 'visiting player profile' do
    context 'rematch links' do
      before do
        visit player_path(player1)
      end

      it 'shows percent won, top played player, game results' do
        within '.rematchLink' do
          expect(page).to have_content('50%')
          expect(page).to have_content('Player 1 vs. Player 2')
          expect(page).to have_content('1 / 1')
        end
      end
    end

    describe 'tournaments' do
      let(:tournament_name) { 'Some Tournament' }
      let(:end_date) { 1.week.from_now.to_s }
      let(:tournament_params) { { name: tournament_name,
                                  players: [player1.id, player2.id],
                                  end_date: end_date } }

      before do
        creator = TournamentCreator.new(tournament_params)
        creator.save
        @tournament = creator.tournament
      end

      context 'active tournaments' do
        it 'shows the matchups for the player' do
          visit player_path(player1.id)
          expect(page).to have_content("#{player1.name} vs #{player2.name}")
        end
      end

      context 'completed tournaments' do
        let(:past_date) { 1.week.ago.to_s }

        it 'shows the players results' do
          @tournament.update_column('end_date', past_date)
          visit player_path(player1.id)
          within '.profile-top-bar' do
            click_link 'Tournaments'
          end
          expect(page).to have_content('Final Rank')
        end
      end
    end

    before do
      visit player_path(player1.id)
    end


    it 'shows player name and rating' do
      expect(page).to have_content(player1.name)
      expect(page).to have_content(player1.rating)
    end

    it 'shows player name and highest rating achieved' do
      statistician =  PlayerStatistician.new(player1)
      expect(page).to have_content(statistician.highest_rating_achieved)
    end

    it 'shows average rating' do
      statistician =  PlayerStatistician.new(player1)
      expect(page).to have_content(statistician.average_rating)
    end

    it 'shows players past games' do
      within '.profile-top-bar' do
        click_link 'Games'
      end
      expect(page).to have_content("Games Played (2)")

      within "#game-#{game1.id}" do
        expect(find('.winner')).to have_content(player1.name)
        expect(find('.loser')).to have_content(player2.name)
      end

      within "#game-#{game2.id}" do
        expect(find('.winner')).to have_content(player2.name)
        expect(find('.loser')).to have_content(player1.name)
      end

      expect(page).to_not have_content(player3.name)
    end
  end
end
