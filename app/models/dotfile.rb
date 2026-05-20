class Dotfile < ApplicationRecord
  belongs_to :blueprint

  validates :name, presence: true
  validates :content, presence: true
  validates :target_path, presence: true, format: { with: /\A\//, message: "must be an absolute path" }
end
