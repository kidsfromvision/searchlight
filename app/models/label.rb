class Label < ApplicationRecord
  has_many :user
  has_many :user_song
end
