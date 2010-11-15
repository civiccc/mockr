require 'test_helper'

class MockListsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:mock_lists)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_mock_list
    assert_difference('MockList.count') do
      post :create, :mock_list => { }
    end

    assert_redirected_to mock_list_path(assigns(:mock_list))
  end

  def test_should_show_mock_list
    get :show, :id => mock_lists(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => mock_lists(:one).id
    assert_response :success
  end

  def test_should_update_mock_list
    put :update, :id => mock_lists(:one).id, :mock_list => { }
    assert_redirected_to mock_list_path(assigns(:mock_list))
  end

  def test_should_destroy_mock_list
    assert_difference('MockList.count', -1) do
      delete :destroy, :id => mock_lists(:one).id
    end

    assert_redirected_to mock_lists_path
  end
end
