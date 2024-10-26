class User < ApplicationRecord

  has_many :cart_items, dependent: :destroy
  has_many :wishlist_items, dependent: :destroy
  has_many :wishlist_products, through: :wishlist_items, source: :product
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Additional validations or relationships if necessary
  validates :email, presence: true, uniqueness: true
end
