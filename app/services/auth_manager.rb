class AuthManager
  class << self
    def token
      api_token = stored_api_token
      api_token.is_expired? ? refresh_api_token.token : api_token.token
    end

    private

    def provider
      raise "Not implemented"
    end

    def stored_api_token
      api_token = ApiToken.where(provider: provider)&.last
      api_token || refresh_api_token
    end

    def refresh_api_token
      ApiToken.create(
        provider: provider,
        token: get_token,
        expires_at: Time.now + 1.hour,
      )
    end
  end
end
