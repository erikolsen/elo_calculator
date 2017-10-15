require 'rails_helper'

describe 'Single Elimination Tournament' do
  let!(:club) { FactoryGirl.create :club, member_count: 7 }
  let(:players) { club.players.sort_by(&:rating).reverse }
  let(:player_1) { players[0] }
  let(:player_2) { players[1] }
  let(:player_3) { players[2] }
  let(:player_4) { players[3] }
  let(:player_5) { players[4] }
  let(:player_6) { players[5] }
  let(:player_7) { players[6] }
  let(:tournament_data) { { name: 'Some Tournamernt',
                            players: players.map(&:id),
                            start_date: Time.now,
                            end_date: 1.week.from_now,
                            type: 'SingleElimination' } }

  context 'single elimination' do
    before do
      creator = TournamentCreator.new(tournament_data)
      creator.save
      visit single_elimination_path(creator.tournament)
    end

    it 'playing the tournament' do
      click_link 'Start Tournament'

      # Tournament Page
      click_link("#{player_4.name} vs. #{player_5.name}")
      find(:css, "#label_games_1_#{player_4.id}").click
      find(:css, "#label_games_2_#{player_4.id}").click
      find(:css, "#label_games_3_#{player_4.id}").click
      find(:css, "input[type='submit']").click
      click_link 'Back to Tournament'

      click_link("#{player_2.name} vs. #{player_7.name}")
      find(:css, "#label_games_1_#{player_7.id}").click
      find(:css, "#label_games_2_#{player_7.id}").click
      find(:css, "#label_games_3_#{player_7.id}").click
      find(:css, "input[type='submit']").click
      click_link 'Back to Tournament'

      click_link("#{player_3.name} vs. #{player_6.name}")
      find(:css, "#label_games_1_#{player_6.id}").click
      find(:css, "#label_games_2_#{player_6.id}").click
      find(:css, "#label_games_3_#{player_6.id}").click
      find(:css, "input[type='submit']").click
      click_link 'Back to Tournament'

      # semis
      click_link("#{player_1.name} vs. #{player_4.name}")
      find(:css, "#label_games_1_#{player_4.id}").click
      find(:css, "#label_games_2_#{player_4.id}").click
      find(:css, "#label_games_3_#{player_4.id}").click
      find(:css, "input[type='submit']").click
      click_link 'Back to Tournament'

      click_link("#{player_7.name} vs. #{player_6.name}")
      find(:css, "#label_games_1_#{player_6.id}").click
      find(:css, "#label_games_2_#{player_6.id}").click
      find(:css, "#label_games_3_#{player_6.id}").click
      find(:css, "input[type='submit']").click
      click_link 'Back to Tournament'

      # finals
      click_link("#{player_4.name} vs. #{player_6.name}")
      find(:css, "#label_games_1_#{player_6.id}").click
      find(:css, "#label_games_2_#{player_6.id}").click
      find(:css, "#label_games_3_#{player_6.id}").click
      find(:css, "input[type='submit']").click
      click_link 'Back to Tournament'

      # losers
      click_link("#{player_1.name} vs. #{player_7.name}")
      find(:css, "#label_games_1_#{player_1.id}").click
      find(:css, "#label_games_2_#{player_1.id}").click
      find(:css, "#label_games_3_#{player_1.id}").click
      find(:css, "input[type='submit']").click
      click_link 'Back to Tournament'

      winner = find(:css, '.winner').text
      expect(winner).to eql player_6.name

      first  = find(:css, '#rank_1').text
      second = find(:css, '#rank_2').text
      third = find(:css, '#rank_3').text
      fourth  = find(:css, '#rank_4').text

      expect(first).to include player_6.name
      expect(second).to include player_4.name
      expect(third).to include player_1.name
      expect(fourth).to include player_7.name
    end
  end
end
