class StreamEvent < ApplicationRecord
  belongs_to :song

  enum :status, %i[unresolved success failed]
  enum :provider, %i[chartmetric spotify]
end
