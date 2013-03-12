require "maildown/version"
require 'nokogiri'

module Maildown

  def self.from_html html
    Parser.new(html).result
  end # self.from_html

  class Parser

    def initialize html
      @doc = Nokogiri::HTML(html)
      @links = []
    end # initialize

    def result
      @result ||= parse
    end

    private

      def parse
        @result = @doc.children.map { |ele| parse_element(ele) }.join + "\n\n" + @links.join("\n")
      end

      def parse_element element
        if element.is_a? Nokogiri::XML::Text
          return "#{element.text}\n"
        else
          if (children = element.children).count > 0
            return wrap_node(element, children.map {|element| parse_element(element)}.join )
          else
            return wrap_node(element, element.text)
          end
        end
      end # parse_element

      # wrap node with markdown
      def wrap_node(node,contents=nil)
        result = ''
        contents.strip! unless contents==nil
        # check if there is a custom parse exist
        if respond_to? "parse_#{node.name}"
          return self.send("parse_#{node.name}",node,contents)
        end
        # skip hidden node
        return '' if node['style'] and node['style'] =~ /display:\s*none/
        # default parse
        case node.name.downcase
        when 'i'
          result << "*#{contents}*"
        when 'p'
          result << "#{contents}\n\n"
        when 'script'
        when 'strike'
          result << "--#{contents}--"
        when 'style'
        when 'li'
          result << "*#{contents}\n"
        when 'blockquote'
          contents.split('\n').each do |part|
            result << ">#{contents}\n"
          end
        when 'b'
          result << "**#{contents}**"
        when 'strong'
          result << "**#{contents}**"
        when 'h1'
          result << "##{contents}\n"
        when 'h2'
          result << "###{contents}\n"
        when 'h3'
          result << "####{contents}\n"
        when 'hr'
          result << "****\n"
        when 'br'
          result << "\n"
        when 'img'
          result << "![#{node['alt']}](#{node['src']})"
        when 'a'
          number = @links.count + 1
          result << "#{contents}[#{number}]"
          @links << "[#{number}] #{node['href']}"
        else
          result << contents unless contents == nil
        end
        result
      end

  end # class

end # module