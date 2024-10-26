module Clients
  class OrdersController < ApplicationController
    def new
      @order = Order.new
    end

    def create
      @order = Order.new(order_params)
      @order.user = current_user

      if @order.save
        session[:cart] = {} # Clear cart after successful order
        redirect_to clients_root_path, notice: 'Order was successfully placed.'
      else
        render :new
      end
    end

    private

    def order_params
      params.require(:order).permit(:address, :payment_method)
    end
  end
end
