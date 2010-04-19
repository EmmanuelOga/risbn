require 'risbn/nokogiri_utils'
require 'open-uri'
require 'ostruct'

class RISBN
  class GData
    attr_reader :isbn

    # Provide an RISBN object or a string to be parsed for an ISBN.
    def initialize(isbn)
      risbn = isbn.is_a?(RISBN) ? isbn : RISBN(isbn)
      risbn.validate!
      @isbn = risbn.to_s
    end

    # google does not allow to access the data directly by isbn
    # so a search is needed first to retrieve the actual google id.
    def search_url
      "http://books.google.com/books/feeds/volumes?q=ISBN#{ isbn }"
    end

    # performs a google search by isbn to retrieve the actual google book id.
    def entry_url
      @info ||= ( Nokogiri(open(search_url).read) / "entry:first" / "id" ).first.inner_text
    rescue => e
      raise RuntimeError, "coult not open search url: #{search_url}  : \n#{e}"
    end

    # returns the original book xml from google.
    def xml
      @entry ||= open(entry_url).read
    rescue => e
      raise RuntimeError, "coult not open entry url: #{entry_url}  : \n#{e}"
    end

    # nokogiri nodes from the xml
    def xml_nodes
      @xml_nodes ||= Nokogiri::XML(xml)
    end

    # hash representation of the google xml
    def to_hash
      @to_hash ||= RISBN::NokogiriUtils.hash_from_node(xml_nodes)[:entry]
    end

    # returns an openstruct with a massaged version of the original xml data.
    def data
      return @data if @data
      google_hash, data = to_hash, BookData.new

      data.creator       = google_hash[:creator]
      data.date          = google_hash[:date]
      data.description   = google_hash[:description]
      data.format        = google_hash[:format]
      data.id            = google_hash[:id]
      data.identifier    = google_hash[:identifier]
      data.language      = google_hash[:language]
      data.publisher     = google_hash[:publisher]

      if google_hash[:rating] && google_hash[:rating][:attributes]
        data.rating        = google_hash[:rating][:attributes][:average].to_f
        data.rating_max    = google_hash[:rating][:attributes][:max].to_f
        data.rating_min    = google_hash[:rating][:attributes][:min].to_f
      end

      data.subject       = google_hash[:subject].map { |s| s.split(/ [\-\/] /) }.flatten.map(&:strip).uniq.sort
      data.title         = google_hash[:title].uniq.join(" ")
      data.updated       = google_hash[:updated]
      data.category      = google_hash[:category]
      data.embeddability = google_hash[:embeddability][:value]
      data.open_access   = google_hash[:openAccess][:value]
      data.viewability   = google_hash[:viewability][:value]

      google_hash[:link].each do |link|
        href = link.is_a?(Hash) ? link[:attributes][:href] : link.last[:href]
        rel  = link.is_a?(Hash) ? link[:attributes][:rel]  : link.last[:rel]
        data.send("#{rel[/thumbnail|info|annotation|alternate|self/]}_url=", href)
      end

      @data = data
    end

    class BookData < OpenStruct
      def to_hash
        @table.dup
      end

      def keys
        @table.keys
      end
    end
  end
end

class RISBN
  def gdata
    @gdata ||= RISBN::GData.new(self)
  end

  def self.GData(isbn)
    RISBN::GData.new(isbn)
  end
end
