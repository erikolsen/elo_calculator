module SingleEliminationPresenter
  def self.present(tournament_matchups)
    original_bracket_matchups = tournament_matchups.to_a.dup
    container = []
    counter = 1
    until original_bracket_matchups.empty?
      container << original_bracket_matchups.pop(counter)
      counter *= 2
    end
    container.reverse
  end
end
