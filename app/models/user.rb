class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :blueprints, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: true

  def to_slug
    name.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/^-|-$/, "")
  end
end
