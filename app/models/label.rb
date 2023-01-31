class Label < ApplicationRecord
  has_many :users
  has_many :tracked_songs
  has_many :songs, through: :tracked_songs
  has_many :invitations
end
