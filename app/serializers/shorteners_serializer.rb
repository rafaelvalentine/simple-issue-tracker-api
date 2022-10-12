class ShortenersSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :url, :shortcode, :title, :access_count, :last_accessed, :is_disabled, :created_at

  attribute :default_shorten_url do |object|
    if ENV["WEB_APP_URL"].present?
      url = ENV["WEB_APP_URL"]
      "#{url}/#{object.shortcode}"
    else
      url = ENV["BASE_DOMAIN"]
      "#{url}/shorteners/#{object.shortcode}"
    end
  end
end
