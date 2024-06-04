require 'rails_helper'

RSpec.describe 'Friendships' do
  let(:valid_attributes) do
    {
      member_id: create(:member).id,
      friend_id: create(:member).id
    }
  end

  let(:invalid_attributes) do
    {
      member_id: create(:member).id,
      friend_id: nil
    }
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/friendships/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Friendship plus inverse' do
        expect do
          post friendships_url, params: { friendship: valid_attributes }
        end.to change(Friendship, :count).by(2)
      end

      it 'redirects to members list' do
        post friendships_url, params: { friendship: valid_attributes }
        expect(response).to redirect_to(members_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Friendship' do
        expect do
          post friendships_url, params: { friendship: invalid_attributes }
        end.not_to change(Friendship, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post friendships_url, params: { friendship: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested friendshp plus inverse' do
      friendship = Friendship.create! valid_attributes
      expect do
        delete friendship_url(friendship)
      end.to change(Friendship, :count).by(-2)
    end

    it 'redirects to the members list' do
      friendship = Friendship.create! valid_attributes
      delete friendship_url(friendship)
      expect(response).to redirect_to(members_url)
    end
  end
end
