module SongsHelper
  def sort_link(column:, label:)
    link_to(label, list_songs_path(column: column))
  end
end
