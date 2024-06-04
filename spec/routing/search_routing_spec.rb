# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController do
  describe 'routing' do
    it 'routes to #index via GET' do
      expect(get: '/').to route_to('search#index')
    end

    it 'routes to #index via POST' do
      expect(post: '/').to route_to('search#index')
    end
  end
end
