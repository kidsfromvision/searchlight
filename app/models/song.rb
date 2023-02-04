class Song < ApplicationRecord
  has_many :tracked_songs, dependent: :destroy
  has_many :user, through: :tracked_songs
  has_many :song_streams, dependent: :destroy
  has_many :stream_events, dependent: :destroy

  def broadcast_streams
    Turbo::StreamsChannel.broadcast_replace_to(
      "streams",
      target: "streams_song_#{self.id}",
      partial: "songs/streams_col",
      locals: {
        song: self,
      },
    )
  end

  def broadcast_streams_loading
    Turbo::StreamsChannel.broadcast_replace_to(
      "streams",
      target: "streams_song_#{self.id}",
      partial: "songs/streams_loading",
      locals: {
        song: self,
      },
    )
  end
end
