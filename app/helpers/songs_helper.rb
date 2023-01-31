module SongsHelper
  def get_readable_status(status)
    readable_statuses = {
      "watching" => "Watching",
      "messaged" => "Messaged",
      "in_conversation" => "In conversation",
      "offered" => "Offered",
      "closed" => "Closed",
    }
    return readable_statuses[status]
  end
end
