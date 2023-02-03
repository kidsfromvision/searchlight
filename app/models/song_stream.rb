class SongStream < ApplicationRecord
  belongs_to :song

  enum :provider, %i[chartmetric spotify]
end
