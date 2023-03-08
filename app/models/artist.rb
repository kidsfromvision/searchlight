class Artist < ApplicationRecord
  has_many :songs, dependent: :destroy
  has_many :geographies, dependent: :destroy
end
