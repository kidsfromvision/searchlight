class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :tracked_songs, dependent: :destroy
  has_many :songs, through: :tracked_songs
  has_many :invitations

  belongs_to :label, optional: true

  enum :role, %i[independent_user label_employee label_admin]
end
