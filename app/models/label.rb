class Label < ApplicationRecord
  has_many :users
  has_many :user_songs, through: :users
  has_many :songs, through: :user_songs
end
