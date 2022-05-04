require 'test_helper'

class MobilityControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mobility_index_url
    assert_response :success
  end

end
