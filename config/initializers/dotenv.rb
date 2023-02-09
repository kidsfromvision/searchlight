if %w[development test].include? ENV["RAILS_ENV"]
  Dotenv.require_keys(
    "SPOTIFY_CLIENT_ID",
    "SPOTIFY_CLIENT_SECRET",
    "CHARTMETRIC_REFRESH_TOKEN",
  )
end
