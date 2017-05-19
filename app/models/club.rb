class Club < ActiveRecord::Base
  has_many :memberships
  has_many :players, through: :memberships

  validates :name, uniqueness: true
  after_save :save_slug

  scope :by_name, -> { order(:name) }

  def to_param
    slug
  end

  def players_by_rating
    players.sort_by(&:rating).reverse
  end

  private

  def save_slug
    update_column('slug', name.downcase.parameterize)
  end
end
