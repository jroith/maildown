require "maildown/version"
require 'nokogiri'

module Maildown

  def self.from_html html
    Parser.new(html).result
  end # self.from_html

  class Parser

    def initialize html
      @doc = Nokogiri::HTML(html.gsub(/\n/, ''))
      @links = []
    end # initialize

    def result
      @result ||= parse
    end

    # private

      def parse
        @result = @doc.children.map { |ele| parse_element(ele) }.join
        @result = @result + "\n\n" + @links.join("\n") if @links.any?
        @result.gsub!(/\n{3,}/, "\n\n") # Removes lines breaks where there are more than two.
        @result.strip!
        @result.lstrip!
        return @result
      end

      def parse_element element
        if element.is_a? Nokogiri::XML::Text
          return element.text.gsub(/^$\n/, '') # remove empty lines
        else
          if (children = element.children).count > 0
            return wrap_node(element, children.map {|element| parse_element(element)}.join )
          else
            return wrap_node(element, element.text)
          end
        end
      end # parse_element

      # wrap node with markdown
      def wrap_node(node, contents=nil)
        result = ''
        # contents.strip! unless contents == nil
        # check if there is a custom parse exist
        if respond_to? "parse_#{node.name}"
          return self.send("parse_#{node.name}", node, contents)
        end
        # skip hidden node
        return '' if node['style'] and node['style'] =~ /display:\s*none/
        # default parse
        case node.name.downcase
        when 'i'
          result << "*#{contents}*"
        when 'p'
          result << "#{contents}\n\n"
        when 'br'
          result << "#{contents}\n"
        when 'script'
        when 'strike'
          result << "--#{contents}--"
        when 'style'
        when 'li'
          result << "*#{contents}\n"
        when 'blockquote'
          result << "\n"
          contents.lines.each do |part|
            result << "> #{part.strip}\n"
          end
          result << "\n"
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
        when 'img'
          result << "![#{node['alt']}](#{node['src']})"
        when 'a'
          if node['href'].start_with? 'mailto:' # skip mailto: links
            result << "#{contents}"
          else
            number = @links.count + 1
            result << "#{contents}[#{number}]"
            @links << "[#{number}] #{node['href']}"
          end
        else
          result << contents unless contents == nil
        end
        result
      end

  end # class

end # module