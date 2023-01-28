class Song < ApplicationRecord
  has_many :user_songs, dependent: :destroy
  has_many :user, through: :user_songs
end
