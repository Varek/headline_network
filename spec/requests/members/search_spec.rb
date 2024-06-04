# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/' do
  let!(:member) { create(:member, name: 'Tester') }
  let!(:headline_member) { create(:member) }
  let!(:headline1) { create(:headline, :h1, member: headline_member) }
  let!(:headline2) { create(:headline, :h2, member: headline_member) }

  before do
    create(:friendship, member:, friend: headline_member)
  end

  describe 'GET /' do
    context 'with a search query' do
      it 'returns the matching headlines', :aggregate_failures do
        post member_search_path(member_id: member.id), params: { search: 'Subtitle' }

        expect(response).to have_http_status(:success)
        expect(response.body).not_to include(headline1.content)
        expect(response.body).to include(headline2.content)
        expect(response.body).to include(CGI.escapeHTML("#{member.name} -> #{headline_member.name}"))
      end

      it 'returns no results if there is no match', :aggregate_failures do
        post member_search_path(member_id: member.id), params: { search: 'Nonexistent' }

        expect(response).to have_http_status(:success)
        expect(response.body).to include('No headlines found!')
      end
    end

    context 'without a search query' do
      it 'returns an empty result set', :aggregate_failures do
        post member_search_path(member_id: member.id), params: { search: '' }

        expect(response).to have_http_status(:success)
        expect(response.body).not_to include(headline1.content)
        expect(response.body).not_to include(headline2.content)
      end
    end
  end
end
