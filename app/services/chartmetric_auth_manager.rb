class ChartmetricAuthManager < AuthManager
  class << self
    private

    def provider
      "chartmetric"
    end

    def get_token
      refresh_token = ENV["CHARTMETRIC_REFRESH_TOKEN"]
      response =
        HTTParty.post(
          "https://api.chartmetric.com/api/token",
          body: {
            "refreshtoken" => refresh_token,
          },
        )
      if response.code == 200
        return response["token"]
      else
        raise "Chartmetric token refresh failed"
      end
    end
  end
end
