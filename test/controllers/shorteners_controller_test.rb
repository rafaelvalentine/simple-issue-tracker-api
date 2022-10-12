require "test_helper"

class ShortenersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shortener = shorteners(:one)
  end

  test "should get index" do
    get shorteners_url, as: :json
    assert_response :success
  end

  test "should create shortener" do
    assert_difference('Shortener.count') do
      post shorteners_url, params: { shortener: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show shortener" do
    get shortener_url(@shortener), as: :json
    assert_response :success
  end

  test "should update shortener" do
    patch shortener_url(@shortener), params: { shortener: {  } }, as: :json
    assert_response 200
  end

  test "should destroy shortener" do
    assert_difference('Shortener.count', -1) do
      delete shortener_url(@shortener), as: :json
    end

    assert_response 204
  end
end
