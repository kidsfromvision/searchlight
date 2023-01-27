module SongsHelper
  def get_readable_status(status)
    readable_statuses = {
      "potential" => "Watching",
      "contacted" => "Contacted",
      "replied" => "Replied",
      "offered" => "Offered",
      "accepted" => "Accepted",
    }
    return readable_statuses[status]
  end
end
