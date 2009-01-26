module Webrat

  class Element # :nodoc:

    def self.load_all(session, dom)
      Webrat::XML.xpath_search(dom, xpath_search).map do |element|
        load(session, element)
      end
    end

    def self.load(session, element)
      return nil if element.nil?
      session.elements[Webrat::XML.xpath_to(element)] ||= self.new(session, element)
    end

    attr_reader :element

    def initialize(session, element)
      @session  = session
      @element  = element
    end

    def path
      Webrat::XML.xpath_to(@element)
    end

    def inspect
      "#<#{self.class} @element=#{element.inspect}>"
    end

    def absolute_href(href_url)
      # Case one: relative url
      if href_url !~ %r{^https?://} && (href_url !~ /^\//)
        "#{@session.current_url.chomp('/')}/#{href_url}"
      # Case two: absolute url without host
      elsif href_url =~ /^\//
        req_host = URI.parse(@session.current_url).host || "www.example.com"
        "http://#{req_host}#{href_url}"
      # Case three: absolute url with scheme and host.
      else
        href_url
      end
    end

  end

end
