require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'users#show action' do
    it 'should allow anyone to view the profile page of a valid user' do
      user = FactoryGirl.create(:user)
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
    it 'should return 404 error if attempting to view profile of nonexistent user' do
      get :show, params: { id: 'DAKINGINDANORF' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
