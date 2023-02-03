class ApiToken < ApplicationRecord
  def is_expired?
    return Time.now >= self.expires_at - 5.minutes
  end

  enum :provider, %i[chartmetric spotify]
end
