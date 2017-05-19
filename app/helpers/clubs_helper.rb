module ClubsHelper
  def all_clubs
    Clubs.by_name
  end
end
