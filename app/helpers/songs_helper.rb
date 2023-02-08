module SongsHelper
  def sort_link(column:, label:)
    if column == params[:column]
      if next_direction.nil?
        link_to(label, root_path)
      else
        link_to(
          label,
          list_songs_path(column: column, direction: next_direction),
        )
      end
    else
      link_to(label, list_songs_path(column: column, direction: "asc"))
    end
  end

  def next_direction
    params[:direction] == "asc" ? "desc" : nil
  end

  def is_sorted_asc
    params[:direction] == "asc"
  end
end
