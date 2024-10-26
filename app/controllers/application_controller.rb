class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:index, :show, :test_connection] # Add test_connection to public routes
  
  def test_connection
    render plain: ActiveRecord::Base.connection.active?.to_s
  end
end
