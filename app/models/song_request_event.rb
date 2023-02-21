class SongRequestEvent < ApplicationRecord
  belongs_to :song

  enum :status, %i[unresolved success failed]
  enum :provider, %i[chartmetric spotify]
  enum :data_requested, %i[streams genres]
end
