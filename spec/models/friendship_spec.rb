require 'rails_helper'

RSpec.describe Friendship do
  describe 'validations' do
    it 'validates that combination of member and friend are unique' do
      member = create(:member)
      friend = create(:member)
      create(:friendship, member:, friend:)
      new_friendship = build(:friendship, member:, friend:)

      expect(new_friendship).not_to be_valid
    end

    it 'validates that member and friend are not the same' do
      member = create(:member)
      friendship = build(:friendship, member:, friend: member)
      expect(friendship).not_to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:member) }
    it { is_expected.to belong_to(:friend) }
  end

  describe 'callbacks' do
    let(:member) { create(:member) }
    let(:friend) { create(:member) }

    context 'when creating a friendship' do
      it 'creates the inverse on create', :aggregate_failures do
        expect do
          create(:friendship, member:, friend:)
        end.to change(described_class, :count).by(2)
        expect(member.friendships.first).not_to eq(friend.friendships.first)
      end
    end

    context 'when destroying a friendship' do
      let!(:friendship) { create(:friendship, member:, friend:) }

      it 'destroys inverse friendship too' do
        expect do
          friendship.destroy
        end.to change(described_class, :count).by(-2)
      end
    end
  end

  describe '#inverse' do
    let(:member) { create(:member) }
    let(:friend) { create(:member) }
    let!(:friendship) { create(:friendship, member:, friend:) }

    it 'returns the inverse friendship', :aggregate_failures do
      expect(friendship.inverse).to eq(friend.friendships.first)
    end
  end
end
