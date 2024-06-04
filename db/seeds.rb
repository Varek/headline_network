# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
10.times do |i|
  member = Member.create!(name: Faker::Name.name, website_url: Faker::Internet.url)
  (11*SecureRandom.random_number(i+2)).times do
    member.headlines.create!(content: Faker::Lorem.sentence, level: %w(h1 h2 h3).sample)
  end
end
