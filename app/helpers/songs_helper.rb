module SongsHelper
  def sort_link(column:, title:, is_label:)
    if column == params[:column]
      if next_direction.nil?
        link_to(title, is_label ? streams_path : label_streams_path, data: { turbo_stream: "true" })
      else
        link_to(
          title,
          (
            if is_label
              label_list_streams_path(column: column, direction: next_direction)
            else
              list_streams_path(column: column, direction: next_direction)
            end
          ),
          data: { turbo_stream: "true" }
        )
      end
    else
      link_to(
        title,
        (
          if is_label
            label_list_streams_path(column: column, direction: "asc")
          else
            list_streams_path(column: column, direction: "asc")
          end
        ),
        data: { turbo_stream: "true" }
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
