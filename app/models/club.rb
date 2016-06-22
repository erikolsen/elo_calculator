class Club < ActiveRecord::Base
  has_many :memberships
  has_many :players, through: :memberships

  validates :name, uniqueness: true
  after_save :save_slug

  def to_param
    slug
  end

  private

  def save_slug
    update_column('slug', name.downcase.parameterize)
  end
end
