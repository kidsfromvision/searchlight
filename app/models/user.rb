class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable

  has_many :tracked_songs, dependent: :destroy
  has_many :songs, through: :tracked_songs

  belongs_to :label, optional: true
end
