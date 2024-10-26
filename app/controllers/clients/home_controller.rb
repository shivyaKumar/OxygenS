module Clients
  class HomeController < ApplicationController
    def index
      # Random products for the slideshow
      @random_products = Product.order("RANDOM()").limit(3)

      # Other sections like on-sale, best-selling, etc.
      @on_sale_products = Product.on_sale.limit(4)
      @best_selling_products = Product.best_selling.limit(4)
      @new_arrivals = Product.new_arrivals.limit(4)
      @womens_wear = Product.joins(:category).where(categories: { name: 'Women' }).limit(4)
      @mens_wear = Product.joins(:category).where(categories: { name: 'Men' }).limit(4)
      @all_products = Product.all
    end
  end
end
