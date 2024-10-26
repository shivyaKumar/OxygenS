class Product < ApplicationRecord
  belongs_to :category # Add this line to establish the association with Category

  has_many :variants, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :sales, through: :variants
  has_one_attached :image
  has_many :product_colors, dependent: :destroy
  has_many :colors, through: :product_colors
  has_many :wishlist_items
  has_many :wishlisted_by_users, through: :wishlist_items, source: :user

  accepts_nested_attributes_for :variants, allow_destroy: true

  # Validations
  validates :name, presence: true, length: { minimum: 3 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 5.megabytes }

  # Scopes for various sections
  scope :on_sale, -> { where(on_sale: true) }
  scope :best_selling, -> { where(best_selling: true) }
  scope :new_arrivals, -> { where(new_arrival: true) }
  
  def self.most_sold
    joins(variants: :sales)
      .group('products.id')
      .order('SUM(sales.quantity) DESC')
      .first
  end

  def self.least_sold
    joins(variants: :sales)
      .group('products.id')
      .order('SUM(sales.quantity) ASC')
      .first
  end

  def self.search(query)
    where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%")
  end
end
