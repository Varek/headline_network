# frozen_string_literal: true

class CollectHeadlinesJob < ApplicationJob
  queue_as :default

  retry_on SocketError, HTTParty::Error, Nokogiri::SyntaxError, wait: :polynomially_longer, attempts: 5

  def perform(member_id)
    member = Member.find(member_id)
    response = HTTParty.get(member.website_url)
    extract_and_save_headlines(member, response)
  rescue SocketError, HTTParty::Error, Nokogiri::SyntaxError => e
    Rails.logger.error("Error while fetching headlines for Member ID #{member_id}: #{e.message}")
    raise e
  end

  def extract_and_save_headlines(member, response)
    return unless response.code == 200 && response.headers['content-type']&.include?('text/html')

    doc = Nokogiri::HTML(response.body)
    headlines = doc.css('h1, h2, h3')

    headlines.each do |headline|
      member.headlines.create(content: headline.text, level: headline.name)
    end
  end
end
