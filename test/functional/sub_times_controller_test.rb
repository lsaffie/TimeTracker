require 'test_helper'

class SubTimesControllerTest < ActionController::TestCase
  setup do
    @sub_time = sub_times(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sub_times)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sub_time" do
    assert_difference('SubTime.count') do
      post :create, :sub_time => @sub_time.attributes
    end

    assert_redirected_to sub_time_path(assigns(:sub_time))
  end

  test "should show sub_time" do
    get :show, :id => @sub_time.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sub_time.to_param
    assert_response :success
  end

  test "should update sub_time" do
    put :update, :id => @sub_time.to_param, :sub_time => @sub_time.attributes
    assert_redirected_to sub_time_path(assigns(:sub_time))
  end

  test "should destroy sub_time" do
    assert_difference('SubTime.count', -1) do
      delete :destroy, :id => @sub_time.to_param
    end

    assert_redirected_to sub_times_path
  end
end
