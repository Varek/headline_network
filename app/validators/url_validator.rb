# frozen_string_literal: true

# Ensure URL is a valid http(s):// URL that matches the given host constraint.
#
# Example:
#
#   validates :youtube_url, url: { host: /(youtube\.com|youtu\.be)\Z/i }
#
class UrlValidator < ActiveModel::EachValidator
  # rubocop:disable Metrics/AbcSize
  def validate_each(record, attribute, value)
    return if value.blank?

    uri = URI.parse(value)

    record.errors.add(attribute, :http_protocol_missing) unless uri.scheme == 'http' || uri.scheme == 'https'
    record.errors.add(attribute, :host_not_allowed) unless options[:host].nil? || uri.host =~ options[:host]
  rescue URI::InvalidURIError
    record.errors.add(attribute, :invalid)
  end
  # rubocop:enable Metrics/AbcSize
end
