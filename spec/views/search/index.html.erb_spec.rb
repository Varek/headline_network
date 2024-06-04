# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'search/index.html.erb' do
  it 'renders a search form' do
    render
    assert_select 'form' do
      assert_select 'input[type="search"]'
      assert_select 'input[type="submit"]'
    end
  end

  it 'renders no search results and heading', :aggregate_failures do
    render
    expect(rendered).not_to include('Results for')
    expect(rendered).not_to include('No headlines found!')
  end

  context 'with search term' do
    let(:search_term) { 'test' }

    before do
      controller.params[:search] = search_term
    end

    it 'renders search result heading but no results' do
      render
      assert_select 'h2', text: "Results for \"#{search_term}\""
      expect(rendered).to include('No headlines found!')
    end

    context 'with matching headline' do
      let!(:member) { create(:member) }
      let!(:headline) { create(:headline, member:, content: 'Testing Headlines') }

      before do
        assign(:headlines, [headline])
      end

      it 'renders heading and search result table' do
        render
        assert_select 'h2', text: "Results for \"#{search_term}\""
        assert_select 'table' do
          assert_select 'thead' do
            assert_select 'th', text: 'Headline', count: 1
            assert_select 'th', text: 'Member', count: 1
          end
          assert_select 'tbody' do
            assert_select 'tr', count: 1 do
              assert_select 'td', text: headline.content, count: 1
              assert_select 'td a', text: member.name, count: 1
            end
          end
        end
      end
    end
  end
end
