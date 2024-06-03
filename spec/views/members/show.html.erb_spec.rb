# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'members/show' do
  before do
    assign(:member, create(:member))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
      .and match(/Website Url/)
  end
end
