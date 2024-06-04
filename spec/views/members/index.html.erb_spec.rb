# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'members/index' do
  let(:members) do
    [
      create(:member),
      create(:member, name: 'Jane Doe', website_url: 'https://janes-example.com')
    ]
  end
  let(:member_headlines_count) { members.to_h { |m| [m.id, m.id] } }

  before do
    assign(:members, members)

    assign(:member_headlines_count, member_headlines_count)
  end

  it 'renders a table of members' do
    render
    assert_select 'table' do
      assert_select 'thead' do
        assert_select 'th', text: 'Name', count: 1
        assert_select 'th', text: 'Website Url', count: 1
        assert_select 'th', text: 'Website Headlines Count', count: 1
      end
      assert_select 'tbody' do
        assert_select 'tr', count: 2 do
          members.each do |member|
            assert_select 'td a', text: member.name, count: 1
            assert_select 'td', text: member.website_url, count: 1
            assert_select 'td', text: member.id.to_s, count: 1
          end
        end
      end
    end
  end
end
