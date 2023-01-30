class TrackedSong < ApplicationRecord
  enum :status, %i[watching contacted replied offered accepted]

  belongs_to :user
  belongs_to :song
  belongs_to :label, optional: true
end
