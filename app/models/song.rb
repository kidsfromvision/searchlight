class Song < ApplicationRecord
  has_many :tracked_songs, dependent: :destroy
  has_many :user, through: :tracked_songs
  has_many :song_streams, dependent: :destroy
  has_many :song_request_events, dependent: :destroy

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

  def broadcast_genres
    Turbo::StreamsChannel.broadcast_replace_to(
      "streams",
      target: "genres_song_#{self.id}",
      partial: "songs/genres_col",
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

  def broadcast_genres_loading
    Turbo::StreamsChannel.broadcast_replace_to(
      "streams",
      target: "genres_song_#{self.id}",
      partial: "songs/genres_loading",
      locals: {
        song: self,
      },
    )
  end

  def recent_daily_streams
    unless recent_streams.nil?
      recent_streams.first.streams - recent_streams.last.streams
    end
  end

  def recent_total_streams
    recent_streams.first.streams unless recent_streams.nil?
  end

  def present_gap_days
    unless recent_streams.nil?
      ((Time.now - recent_streams.first.date) / 60 / 60 / 24).to_i
    end
  end

  def stream_gap_days
    unless recent_streams.nil?
      (
        (recent_streams.first.date - recent_streams.last.date) / 60 / 60 / 24
      ).to_i
    end
  end

  def up_to_date
    stream_gap_days == 1 && present_gap_days == 0
  end

  private

  def recent_streams
    @recent_streams ||=
      song_streams
        .order(date: :desc)
        .each_cons(2)
        .detect { |a, b| (a.streams - b.streams).nonzero? }
  end
end
