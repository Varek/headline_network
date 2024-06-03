# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'members/index' do
  before do
    assign(:members, [
             create(:member),
             create(:member, name: 'Jane Doe', website_url: 'https://janes-example.com')
           ])
  end

  it 'renders a list of members' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Name'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('Website Url'.to_s), count: 2
  end
end
