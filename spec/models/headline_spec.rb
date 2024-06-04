# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Headline do
  subject { build(:headline) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:level) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:member) }
  end
end
