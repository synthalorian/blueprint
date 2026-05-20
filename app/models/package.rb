class Package < ApplicationRecord
  belongs_to :blueprint

  validates :name, presence: true
  validates :version, length: { maximum: 50 }
  validates :category, presence: true, inclusion: { in: %w[pacman aur pip npm gem cargo go flatpak snap brew custom] }

  scope :by_category, -> { group(:category).order(:category) }
end
