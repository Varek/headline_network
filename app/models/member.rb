# frozen_string_literal: true

class Member < ApplicationRecord
  validates :name, presence: true
  validates :website_url, presence: true, url: true

  has_many :headlines, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  def shortest_connection_to(other_member) # rubocop:disable Metrics/MethodLength
    # Breadth-first search to find the shortest connection between two members
    return [self] if self == other_member

    visited = {}
    queue = [[self]]

    while queue.any?
      path = queue.shift
      current_member = path.last

      next unless visited[current_member.id].nil?

      visited[current_member.id] = true

      current_member.friends.each do |friend|
        new_path = path + [friend]
        return new_path if friend == other_member

        queue << new_path
      end
    end

    [] # No connection found
  end
end
