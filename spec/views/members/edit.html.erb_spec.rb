# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'members/edit' do
  let(:member) do
    create(:member)
  end

  before do
    assign(:member, member)
  end

  it 'renders the edit member form' do
    render

    assert_select 'form[action=?][method=?]', member_path(member), 'post' do
      assert_select 'input[name=?]', 'member[name]'

      assert_select 'input[name=?]', 'member[website_url]'
    end
  end
end
