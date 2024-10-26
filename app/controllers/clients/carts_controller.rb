module Clients
  class CartsController < ApplicationController
    # before_action :authenticate_user!, except: [:index, :show, :add_item]  # Ensure it's commented out if not using

    before_action :set_cart, only: [:show, :confirm]

    def show
      @cart_items = CartItem.where(user_id: current_user.id)
    end

    def add_item
      product = Product.find(params[:product_id])
      variant = product.variants.find_by(color: params[:color], size: params[:size])

      if variant && variant.quantity >= params[:quantity].to_i
        session[:cart] ||= {}
        cart_item_key = "#{product.id}_#{variant.color}_#{variant.size}"
        session[:cart][cart_item_key] = (session[:cart][cart_item_key] || 0) + params[:quantity].to_i

        CartItem.create(
          user_id: current_user.id,
          product_id: product.id,
          color: params[:color],
          size: params[:size],
          quantity: params[:quantity].to_i
        )

        flash[:notice] = 'Item successfully added to the cart.'
        redirect_to clients_cart_path
      else
        flash[:alert] = 'Not enough stock available.'
        redirect_back(fallback_location: clients_product_path(product))
      end
    end

    def update_quantity
      cart_item = CartItem.find_by(id: params[:id], user_id: current_user.id)
      if cart_item
        new_quantity = params[:quantity].to_i
        if new_quantity > 0
          cart_item.update(quantity: new_quantity)
          flash[:notice] = 'Quantity updated successfully.'
        else
          flash[:alert] = 'Quantity must be greater than zero.'
        end
      else
        flash[:alert] = 'Item not found in the cart.'
      end
    
      redirect_to clients_cart_path
    end
    

    def confirm
      @cart_items = CartItem.where(user_id: current_user.id)
      redirect_to clients_cart_path, notice: 'Your cart has been successfully confirmed!'
    end

    def remove_item
      cart_item = CartItem.find_by(user_id: current_user.id, product_id: params[:id])
      cart_item.destroy if cart_item
      redirect_to clients_cart_path, notice: 'Item removed from cart.'
    end

    private

    def set_cart
      @cart_items = CartItem.where(user_id: current_user.id)
    end
  end
end
