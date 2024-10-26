class Clients::WishlistsController < ApplicationController
  before_action :authenticate_user! # Ensure the user is logged in

  def index
    @wishlist_items = current_user.wishlist_items
  end

  def create
    product = Product.find(params[:product_id])

    # Check if the product is already in the user's wishlist
    if current_user.wishlist_items.exists?(product_id: product.id)
      flash[:alert] = "#{product.name} is already in your wishlist."
    else
      current_user.wishlist_items.create(product: product)
      flash[:notice] = "#{product.name} has been added to your wishlist."
    end

    redirect_to clients_wishlists_path
  end

  def destroy
    wishlist_item = current_user.wishlist_items.find(params[:id])
    wishlist_item.destroy
    flash[:notice] = "Item has been removed from your wishlist."
    redirect_to clients_wishlists_path
  end
end
