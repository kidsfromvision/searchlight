class Artist < ApplicationRecord
  # kill a man, kill his children
  has_many :songs, dependent: :destroy
  has_many :geographies, dependent: :destroy
end
