module HomeHelper
  def get_readable_status(status)
    readable_statuses = {
      "not_contacted" => "Not contacted",
      "contacted" => "Contacted",
      "replied" => "Replied",
      "offered" => "Offered",
      "accepted" => "Accepted",
    }
    return readable_statuses[status]
  end
end
