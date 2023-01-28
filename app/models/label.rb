class Label < ApplicationRecord
  has_many :user
  has_many :user_songs, through: :user
  has_many :song, through: :user_songs
end
