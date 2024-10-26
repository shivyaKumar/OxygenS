class ProductsController < ApplicationController
  
  def index
    # Fetch all products initially
    @products = Product.all

    # Apply search filtering by name or description
    if params[:query].present?
      @products = @products.where("name LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    end

    # Apply category, color, and size filters (supports multiple selections)
    @products = @products.where(category: params[:category]) if params[:category].present?
    @products = @products.where(color: params[:color]) if params[:color].present?
    @products = @products.where(size: params[:size]) if params[:size].present?

    # Apply price range filtering if both min and max prices are provided
    if params[:price_min].present? && params[:price_max].present?
      @products = @products.where(price: params[:price_min]..params[:price_max])
    end

    # Respond with HTML for normal requests or JS for AJAX requests
    respond_to do |format|
      format.html # For normal page load
      format.js   # For AJAX-based filtering
    end
  end

  def show
    @product = Product.find(params[:id])
    render 'admin/products/show'
  end

  def create
    @product = Product.new(product_params)
    
    if @product.save
      redirect_to admin_product_path(@product), notice: 'Product was successfully created.'
    else
      render 'admin/products/index'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      redirect_to admin_products_path, notice: 'Product was successfully deleted.'
    else
      redirect_to admin_product_path(@product), alert: 'Failed to delete the product.'
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :image, variants_attributes: [:id, :color, :size, :quantity, :_destroy])
  end
end

