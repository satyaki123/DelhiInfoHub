require 'test_helper'

class PlacesDataControllerTest < ActionController::TestCase
  test "should get get_place_data" do
    get :get_place_data
    assert_response :success
  end

end
