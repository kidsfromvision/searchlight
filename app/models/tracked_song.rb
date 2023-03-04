class TrackedSong < ApplicationRecord
  enum :status, %i[watching messaged in_conversation offered closed]

  belongs_to :user
  belongs_to :song
  belongs_to :label, optional: true

  after_create_commit :broadcast_add_to_user
  after_update_commit :broadcast_replace
  after_destroy_commit :broadcast_remove

  def broadcast_add_to_user
    song = Song.find_by(id: self.song_id)
    Turbo::StreamsChannel.broadcast_append_later_to(
      self.user,
      target: "user_table",
      partial: "songs/song",
      locals: {
        song: song,
        user: self.user,
        is_label: false,
        animate_in: true,
      },
    )
  end

  def broadcast_add_to_label
    song = Song.find_by(id: self.song_id)
    Turbo::StreamsChannel.broadcast_append_later_to(
      self.user.label,
      target: "label_table",
      partial: "songs/song",
      locals: {
        song: song,
        user: self.user,
        is_label: true,
        animate_in: true,
      },
    )
  end

  def broadcast_replace
    song = Song.find_by(id: self.song_id)
    broadcast_replace_later_to(
      self.user,
      target: "song_#{song.id}",
      partial: "songs/song",
      locals: {
        song: song,
        user: self.user,
        is_label: false,
        animate_in: false,
      },
    )

    unless self.label_id.nil?
      broadcast_replace_later_to(
        self.user.label,
        target: "song_#{song.id}",
        partial: "songs/song",
        locals: {
          song: song,
          user: self.user,
          is_label: true,
          animate_in: false,
        },
      )
    end
  end

  def broadcast_remove
    Turbo::StreamsChannel.broadcast_remove_to(
      self.user,
      target: "song_#{self.song_id}",
    )

    unless self.label_id.nil?
      Turbo::StreamsChannel.broadcast_remove_to(
        self.user.label,
        target: "song_#{self.song_id}",
      )
    end
  end
end
