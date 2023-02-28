module SongsHelper
  def sort_link(column:, label:, is_label:)
    if column == params[:column]
      if next_direction.nil?
        link_to(label, is_label ? label_leaderboard_path : root_path)
      else
        link_to(
          label,
          (
            if is_label
              label_list_songs_path(column: column, direction: next_direction)
            else
              list_songs_path(column: column, direction: next_direction)
            end
          ),
        )
      end
    else
      link_to(
        label,
        (
          if is_label
            label_list_songs_path(column: column, direction: "asc")
          else
            list_songs_path(column: column, direction: "asc")
          end
        ),
      )
    end
  end

  def next_direction
    params[:direction] == "asc" ? "desc" : nil
  end

  def is_sorted_asc
    params[:direction] == "asc"
  end
end
