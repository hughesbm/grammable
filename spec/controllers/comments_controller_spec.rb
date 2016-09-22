require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'comments#create action' do
    it 'should successfully create a new comment in the db' do
      gram = FactoryGirl.create(:gram)

      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { gram_id: gram.id, comment: { message: 'sweet gram bruh' } }
      expect(response).to redirect_to gram_path(gram)

      expect(gram.comments.count).to eq 1
      expect(gram.comments.first.message).to eq 'sweet gram bruh'
    end
    it 'should require users to be logged in to create a comment' do
      gram = FactoryGirl.create(:gram)

      post :create, params: { gram_id: gram.id, comment: { message: 'sweet gram bruh' } }
      expect(response).to redirect_to new_user_session_path
    end
    it 'should return a 404 error if trying to create a comment on an invalid gram' do
      user = FactoryGirl.create(:user)
      sign_in user
      
      post :create, params: { gram_id: 'TACOCAT', comment: { message: 'sweet gram bruh' } }
      expect(response).to have_http_status :not_found
    end
  end

end
