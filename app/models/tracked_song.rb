class TrackedSong < ApplicationRecord
  enum :status, %i[watching messaged in_conversation offered closed]

  belongs_to :user
  belongs_to :song
  belongs_to :label, optional: true

  def broadcast_add(user)
    song = Song.find_by(id: self.song_id)
    Turbo::StreamsChannel.broadcast_append_to(
      broadcast_receiver(user),
      target: "table",
      partial: "songs/song",
      locals: {
        song: song,
        user: user,
      },
    )
  end

  def broadcast_replace(user)
    song = Song.find_by(id: self.song_id)
    Turbo::StreamsChannel.broadcast_replace_to(
      broadcast_receiver(user),
      target: "song_#{song.id}",
      partial: "songs/song",
      locals: {
        song: song,
        user: user,
      },
    )
  end

  def broadcast_remove(user)
    Turbo::StreamsChannel.broadcast_remove_to(
      broadcast_receiver(user),
      target: "song_#{self.song_id}",
    )
  end

  private

  def broadcast_receiver(user)
    if user.label_id
      "label_leaderboard_#{user.label_id}"
    else
      "user_leaderboard_#{user.id}"
    end
  end
end
