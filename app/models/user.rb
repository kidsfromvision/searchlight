class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable

  has_and_belongs_to_many :song
  belongs_to :label, optional: true

  def self.label_name(user_id)
    joins(:label).select("labels.name").find(user_id).name
  end
end
