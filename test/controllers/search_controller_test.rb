require 'test_helper'

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search_url" do
    get search_search_url_url
    assert_response :success
  end

end
