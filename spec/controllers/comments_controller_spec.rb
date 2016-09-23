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
  describe 'comments#destroy action' do
    it 'should successfully allow comment owner to delete a comment' do
      comment = FactoryGirl.create(:comment)

      sign_in comment.user

      post :create, params: { gram_id: comment.gram.id, comment: { message: 'sweet gram bruh' } }

      delete :destroy, params: { id: comment.id }
      expect(response).to redirect_to gram_path(comment.gram)

      comment = Comment.find_by_id(comment.id)
      expect(comment).to eq nil
    end
    it 'should successfully allow gram owner to delete a comment' do
      gram = FactoryGirl.create(:gram)
      gram_owner = gram.user

      comment_owner = FactoryGirl.create(:user)
      sign_in comment_owner

      post :create, params: { gram_id: gram.id, comment: { message: 'sweet gram bruh' } }

      sign_out comment_owner
      sign_in gram_owner

      delete :destroy, params: { id: gram.comments.first.id }
      expect(response).to redirect_to gram_path(gram)

      expect(gram.comments.count).to eq 0
    end
    it 'should not a user other than the comment or gram author to delete a comment' do
      comment = FactoryGirl.create(:comment)

      user = FactoryGirl.create(:user)
      sign_in user

      delete :destroy, params: { id: comment.id }
      expect(response).to have_http_status :forbidden
    end
    it 'should require a user to be logged in to delete a comment' do
      comment = FactoryGirl.create(:comment)

      delete :destroy, params: { id: comment.id }
      expect(response).to redirect_to new_user_session_path
    end
    it 'should return a 404 error if trying to delete a comment that does not exist' do
      user = FactoryGirl.create(:user)
      sign_in user

      delete :destroy, params: { id: 'DAKINGINDANORF' }
      expect(response).to have_http_status :not_found
    end
  end

end
