# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'members/new' do
  before do
    assign(:member, Member.new(
                      name: 'MyString',
                      website_url: 'MyString'
                    ))
  end

  it 'renders new member form' do
    render

    assert_select 'form[action=?][method=?]', members_path, 'post' do
      assert_select 'input[name=?]', 'member[name]'

      assert_select 'input[name=?]', 'member[website_url]'
    end
  end
end
