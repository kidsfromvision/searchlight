class ChartmetricApiToken < ApplicationRecord
    def expired?
      Time.now > self.expiry - 5.minutes
    end
  
    def refresh
      self.create_new_key
    end
    
    def self.response 
      refresh_token = ENV["CHARTMETRIC_REFRESH_TOKEN"] 
      response =
        HTTParty.post(
          "https://api.chartmetric.com/api/token",
          body: {"refreshtoken" => refresh_token}
        )
        return response["token1"]
    end

    private
  
    def create_new_key
      refresh_token = ENV["CHARTMETRIC_REFRESH_TOKEN"] 
      response =
        HTTParty.post(
          "https://api.chartmetric.com/api/token",
          body: {"refreshtoken" => refresh_token}
        )
      if response.code == 200
        ChartmetricApiToken.create(
          token: response["token"],
          expiry: Time.now + 1.hours,
        )
        self.destroy
      end
    end
  end
  