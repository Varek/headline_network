# frozen_string_literal: true

FactoryBot.define do
  factory :headline do
    member
    content { 'Headline' }
    level { 'h1' }
  end

  trait :h1 do
    content { 'Title line' }
    level { 'h1' }
  end

  trait :h2 do
    content { 'Subtitle line' }
    level { 'h2' }
  end

  trait :h3 do
    content { 'Content line' }
    level { 'h3' }
  end
end
