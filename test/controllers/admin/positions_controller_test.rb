require 'test_helper'

class Admin::PositionsControllerTest < ActionController::TestCase
  setup do
    @admin_position = admin_positions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_positions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_position" do
    assert_difference('Admin::Position.count') do
      post :create, admin_position: { rank: @admin_position.rank, title: @admin_position.title }
    end

    assert_redirected_to admin_position_path(assigns(:admin_position))
  end

  test "should show admin_position" do
    get :show, id: @admin_position
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_position
    assert_response :success
  end

  test "should update admin_position" do
    patch :update, id: @admin_position, admin_position: { rank: @admin_position.rank, title: @admin_position.title }
    assert_redirected_to admin_position_path(assigns(:admin_position))
  end

  test "should destroy admin_position" do
    assert_difference('Admin::Position.count', -1) do
      delete :destroy, id: @admin_position
    end

    assert_redirected_to admin_positions_path
  end
end
