class Club < ActiveRecord::Base
  has_many :memberships
  has_many :players, through: :memberships

  def to_param
    self.name.parameterize
  end
end
