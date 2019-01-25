require 'test_helper'

class CountControllerTest < ActionDispatch::IntegrationTest
  test "should get report" do
    get count_report_url
    assert_response :success
  end

end
