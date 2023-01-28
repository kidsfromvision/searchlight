class UserSong < ApplicationRecord
  enum :status, %i[watching contacted replied offered accepted]

  belongs_to :user
  belongs_to :song
end
