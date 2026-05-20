class Service < ApplicationRecord
  belongs_to :blueprint

  validates :name, presence: true

  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }
end
