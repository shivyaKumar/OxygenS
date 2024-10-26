module Clients
  class ProductsController < ApplicationController
    def index
      @products = Product.all
      @categories = Category.all
      @colors = Variant.pluck(:color).uniq
      @sizes = Variant.pluck(:size).uniq

      respond_to do |format|
        format.html # for full page reloads
        format.js   # for AJAX requests
      end
    end

    def men
      # Fetch men's products
      @colors = Variant.pluck(:color).uniq # Retrieve unique colors from the variants table
      @sizes = Variant.pluck(:size).map { |s| s.strip.upcase }.uniq.sort_by { |s| ['XS', 'S', 'M', 'L', 'XL', '2XL', '3XL'].index(s) }

      # Initialize the @products variable to filter by default Shirt and T-Shirt
      @products = Product.where(name: ['Shirt', 'T-Shirt', 'Sports', 'Belt', 'Suit', 'Vest'])

      # Filter by category (if selected)
      if params[:category].present?
        @products = @products.where(name: params[:category])
      end

      # Filter by color (if selected)
      if params[:color].present?
        @products = @products.joins(:variants).where(variants: { color: params[:color] })
      end

      # Filter by size (if selected)
      if params[:size].present?
        @products = @products.joins(:variants).where(variants: { size: params[:size] })
      end

      # Filter by price (inclusive of the max price selected)
      if params[:price_max].present?
        @products = @products.where('price <= ?', params[:price_max].to_f)
      end

      # Remove duplicates by using distinct to ensure each product is listed only once
      @products = @products.distinct

      # If no products are found after filtering, show a flash notice
      if @products.empty?
        flash[:notice] = "The Product is not available"
      end
    end

    def women
      # Fetch women's products
      @colors = Variant.pluck(:color).uniq # Retrieve unique colors from the variants table
      @sizes = Variant.pluck(:size).map { |s| s.strip.upcase }.uniq.sort_by { |s| ['XS', 'S', 'M', 'L', 'XL', '2XL', '3XL'].index(s) }
    
      # Initialize the @products variable to filter by default Dress, Top, Jeans, Skirt
      @products = Product.where(name: ['Dress', 'Top', 'Jeans', 'Skirt', 'Shorts', 'Tees'])
    
      # Filter by category (if selected)
      if params[:category].present?
        @products = @products.where(name: params[:category])
      end
    
      # Filter by color (if selected)
      if params[:color].present?
        @products = @products.joins(:variants).where(variants: { color: params[:color] })
      end
    
      # Filter by size (if selected)
      if params[:size].present?
        @products = @products.joins(:variants).where(variants: { size: params[:size] })
      end
    
      # Filter by price (inclusive of the max price selected)
      if params[:price_max].present?
        @products = @products.where('price <= ?', params[:price_max].to_f)
      end
    
      # Remove duplicates by using distinct to ensure each product is listed only once
      @products = @products.distinct
    
      # If no products are found after filtering, show a flash notice
      if @products.empty?
        flash[:notice] = "No products available for women's wear."
      end
    end
  end    
end