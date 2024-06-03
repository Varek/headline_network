# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    name { 'Mister example' }
    website_url { 'https://example.com' }
  end
end
