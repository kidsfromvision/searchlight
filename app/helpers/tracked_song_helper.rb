module TrackedSongHelper
  def get_readable_status(status)
    return readable_statuses[status]
  end

  def get_status_options
    readable_statuses.map do |status, readable_status|
      [readable_status, status]
    end
  end

  private

  def readable_statuses
    @readable_statuses = {
      "watching" => "Watching",
      "messaged" => "Messaged",
      "in_conversation" => "In conversation",
      "offered" => "Offered",
      "closed" => "Closed",
    }
  end
end
