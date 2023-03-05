module ArchivesHelper
  def archives_table_classes(name)
    if name == :name
      return(
        "py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-black sm:pl-6 md:pl-0"
      )
    elsif name == :artist
      return("py-3.5 px-3 text-left text-sm font-semibold text-black")
    elsif name == :added_by
      return(
        "py-3.5 px-3 text-left text-sm font-semibold text-black search-result search-result-1"
      )
    else
      return "py-3.5 px-3 text-left text-sm font-semibold text-black"
    end
  end
end
