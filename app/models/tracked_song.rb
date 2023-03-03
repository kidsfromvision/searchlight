class TrackedSong < ApplicationRecord
  enum :status, %i[watching messaged in_conversation offered closed]

  belongs_to :user
  belongs_to :song
  belongs_to :label, optional: true

  def broadcast_add_to_user(user)
    song = Song.find_by(id: self.song_id)
    Turbo::StreamsChannel.broadcast_append_to(
      user_broadcast_receiver(user),
      target: "user_table",
      partial: "songs/song",
      locals: {
        song: song,
        user: user,
        is_label: false,
        animate_in: true
      },
    )
  end

  def broadcast_add_to_label(user)
    song = Song.find_by(id: self.song_id)
    Turbo::StreamsChannel.broadcast_append_to(
      label_broadcast_receiver(user),
      target: "label_table",
      partial: "songs/song",
      locals: {
        song: song,
        user: user,
        is_label: true,
        animate_in: true
      },
    )
  end

  def broadcast_replace(user)
    song = Song.find_by(id: self.song_id)
    puts "broadcasting replace to #{user_broadcast_receiver(user)}"
    Turbo::StreamsChannel.broadcast_replace_to(
      user_broadcast_receiver(user),
      target: "song_#{song.id}",
      partial: "songs/song",
      locals: {
        song: song,
        user: user,
        is_label: false,
      },
    )

    unless label_broadcast_receiver(user).nil? or self.label_id.nil?
      Turbo::StreamsChannel.broadcast_replace_to(
        label_broadcast_receiver(user),
        target: "song_#{song.id}",
        partial: "songs/song",
        locals: {
          song: song,
          user: user,
          is_label: true,
        },
      )
    end
  end

  def broadcast_remove(user)
    Turbo::StreamsChannel.broadcast_remove_to(
      user_broadcast_receiver(user),
      target: "song_#{self.song_id}",
    )

    unless label_broadcast_receiver(user).nil? or self.label_id.nil?
      Turbo::StreamsChannel.broadcast_remove_to(
        label_broadcast_receiver(user),
        target: "song_#{self.song_id}",
      )
    end
  end

  private

  def label_broadcast_receiver(user)
    "label_leaderboard_#{user.label_id}" unless user.label_id.nil?
  end

  def user_broadcast_receiver(user)
    "user_leaderboard_#{user.id}"
  end
end
