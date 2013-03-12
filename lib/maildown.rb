require "maildown/version"
require 'nokogiri'

module Maildown
  def self.from_html html
    Nokogiri::HTML(html).inner_text
  end
end
