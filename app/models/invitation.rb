class Invitation < ApplicationRecord
  belongs_to :label
  belongs_to :user

  enum :status, %i[unresolved, accepted, declined]
end
