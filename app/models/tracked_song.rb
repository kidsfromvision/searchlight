class TrackedSong < ApplicationRecord
  enum :status, %i[watching messaged in_conversation offered closed]

  belongs_to :user
  belongs_to :song
  belongs_to :label, optional: true

  def broadcast_add(user)
    song = Song.find_by(id: self.song_id)
    Turbo::StreamsChannel.broadcast_append_to(
      user_broadcast_receiver,
      target: "user_table",
      partial: "songs/song",
      locals: {
        song: song,
        user: user,
        is_label: false,
      },
    )
  end

  def broadcast_replace(user)
    song = Song.find_by(id: self.song_id)
    Turbo::StreamsChannel.broadcast_replace_to(
      user_broadcast_receiver,
      target: "song_#{song.id}",
      partial: "songs/song",
      locals: {
        song: song,
        user: user,
      },
    )

    unless label_broadcast_receiver.nil? or self.label_id.nil?
      Turbo::StreamsChannel.broadcast_replace_to(
        label_broadcast_receiver,
        target: "song_#{song.id}",
        partial: "songs/song",
        locals: {
          song: song,
          user: user,
        },
      )
    end
  end

  def broadcast_remove(user)
    Turbo::StreamsChannel.broadcast_remove_to(
      user_broadcast_receiver,
      target: "song_#{self.song_id}",
    )

    unless label_broadcast_receiver.nil? or self.label_id.nil?
      Turbo::StreamsChannel.broadcast_remove_to(
        label_broadcast_receiver,
        target: "song_#{self.song_id}",
      )
    end
  end

  private

  def label_broadcast_receiver
    "label_leaderboard_#{user.label_id}" unless user.label_id.nil?
  end

  def user_broadcast_receiver
    "user_leaderboard_#{user.id}"
  end
end
