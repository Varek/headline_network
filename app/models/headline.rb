# frozen_string_literal: true

class Headline < ApplicationRecord
  belongs_to :member

  validates :content, :level, presence: true
end
