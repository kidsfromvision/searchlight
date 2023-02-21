module SongHelper
  def total_streams_readable(number)
    number_to_human(
      number,
      units: {
        unit: "",
        thousand: "K",
        million: "M",
        billion: "B",
      },
    ).gsub(" ", "") + " all time"
  end
end
