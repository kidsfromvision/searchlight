module SongsHelper
  def table_header_classes(name)
    if name == "name"
      return(
        "py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-black sm:pl-6 md:pl-0"
      )
    elsif name == "genres"
      return(
        "py-3.5 px-3 text-left text-sm font-semibold text-black search-result search-result-1"
      )
    elsif name == "status"
      return(
        "py-3.5 px-3 text-left text-sm font-semibold text-black search-result search-result-2"
      )
    elsif name == "added_by"
      return(
        "py-3.5 px-3 text-left text-sm font-semibold text-black search-result search-result-3"
      )
    else
      return "py-3.5 px-3 text-left text-sm font-semibold text-black"
    end
  end
end
