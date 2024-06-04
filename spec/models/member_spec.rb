# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Member do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:website_url) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:headlines) }
    it { is_expected.to have_many(:friendships) }
    it { is_expected.to have_many(:friends).through(:friendships) }
  end
end
