module SongsHelper
  def get_readable_status(status)
    readable_statuses = {
      "watching" => "Watching",
      "contacted" => "Contacted",
      "replied" => "Replied",
      "offered" => "Offered",
      "accepted" => "Accepted",
    }
    return readable_statuses[status]
  end
end
