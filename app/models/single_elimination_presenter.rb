module SingleEliminationPresenter
  def self.present(tournament_matchups)
    bar = tournament_matchups.to_a
    foo = []
    x = 1
    until bar.empty?
      foo << bar.pop(x)
      x *= 2
    end
    foo.reverse
  end
end
