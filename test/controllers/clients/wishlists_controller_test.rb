require "test_helper"

class Clients::WishlistsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get clients_wishlists_index_url
    assert_response :success
  end

  test "should get create" do
    get clients_wishlists_create_url
    assert_response :success
  end

  test "should get destroy" do
    get clients_wishlists_destroy_url
    assert_response :success
  end
end
