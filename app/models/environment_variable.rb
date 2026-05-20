class EnvironmentVariable < ApplicationRecord
  belongs_to :blueprint

  validates :key, presence: true, format: { with: /\A[A-Z_][A-Z0-9_]*\z/, message: "must be a valid env var name" }
  validates :value, presence: true
end
