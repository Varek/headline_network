# frozen_string_literal: true

class Member < ApplicationRecord
  validates :name, presence: true
  validates :website_url, presence: true, url: true

  has_many :headlines, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
end
