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

  describe '#shortest_connection_to' do
    let(:member1) do
      create(:member, name: 'Member 1')
    end
    let(:member2) do
      create(:member, name: 'Member 2')
    end
    let(:member3) do
      create(:member, name: 'Member 3')
    end
    let(:member4) do
      create(:member, name: 'Member 4')
    end

    before do
      member1.friends << member2
      member2.friends << member3
      member3.friends << member4
      member4.friends << member1
    end

    it 'returns the member itself if the other member is the same' do
      expect(member1.shortest_connection_to(member1)).to eq([member1])
    end

    it 'returns the shortest connection path between two members' do
      expect(member1.shortest_connection_to(member3)).to eq([member1, member2, member3])
    end

    it 'returns the shortest connection path between two members with a direct connection' do
      expect(member1.shortest_connection_to(member4)).to eq([member1, member4])
    end

    it 'returns an empty array if no connection is found' do
      expect(member1.shortest_connection_to(create(:member))).to eq([])
    end
  end
end
