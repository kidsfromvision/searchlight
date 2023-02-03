class Song < ApplicationRecord
  has_many :tracked_songs, dependent: :destroy
  has_many :user, through: :tracked_songs
  has_many :song_streams, dependent: :destroy
end
