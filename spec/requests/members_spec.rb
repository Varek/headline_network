# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/members' do
  # This should return the minimal set of attributes required to create a valid
  # Member. As you add validations to Member, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      name: 'John Doe',
      website_url: 'https://example.com'
    }
  end

  let(:invalid_attributes) do
    {
      name: 'John Doe',
      website_url: nil
    }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Member.create! valid_attributes
      get members_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      member = Member.create! valid_attributes
      get member_url(member)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_member_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      member = Member.create! valid_attributes
      get edit_member_url(member)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Member' do
        expect do
          post members_url, params: { member: valid_attributes }
        end.to change(Member, :count).by(1)
      end

      it 'redirects to the created member' do
        post members_url, params: { member: valid_attributes }
        expect(response).to redirect_to(member_url(Member.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Member' do
        expect do
          post members_url, params: { member: invalid_attributes }
        end.not_to change(Member, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post members_url, params: { member: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'Jane Doe' }
      end

      it 'updates the requested member' do
        member = Member.create! valid_attributes
        patch member_url(member), params: { member: new_attributes }
        member.reload
        expect(member.name).to eq('Jane Doe')
      end

      it 'redirects to the member' do
        member = Member.create! valid_attributes
        patch member_url(member), params: { member: new_attributes }
        member.reload
        expect(response).to redirect_to(member_url(member))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        member = Member.create! valid_attributes
        patch member_url(member), params: { member: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested member' do
      member = Member.create! valid_attributes
      expect do
        delete member_url(member)
      end.to change(Member, :count).by(-1)
    end

    it 'redirects to the members list' do
      member = Member.create! valid_attributes
      delete member_url(member)
      expect(response).to redirect_to(members_url)
    end
  end
end
