class TrackedSong < ApplicationRecord
  enum :status, %i[watching messaged in_conversation offered closed]

  belongs_to :user
  belongs_to :song
  belongs_to :label, optional: true
end
