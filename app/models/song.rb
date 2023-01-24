class Song < ApplicationRecord
  enum :status, %i[not_contacted contacted replied offered accepted]

  has_and_belongs_to_many :user
end
