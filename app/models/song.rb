class Song < ApplicationRecord
  enum :status, %i[potential contacted replied offered accepted]

  has_and_belongs_to_many :user

  after_update_commit :update_leaderboard

  def update_leaderboard
    Turbo::StreamsChannel.broadcast_replace_to(
      "leaderboard",
      target: "song_#{self.id}",
      partial: "songs/song",
      locals: {
        song: self,
      },
    )
  end
end
