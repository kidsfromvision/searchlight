module AssetHelper
  def asset_exists?(path)
    File.exist?("app/assets/images/" + path)
  end
end
