# frozen_string_literal: true

class Headline < ApplicationRecord
  belongs_to :member

  validates :content, :level, presence: true

  def self.search_by_content(content)
    where('content ILIKE ?', "%#{content}%")
  end
end
