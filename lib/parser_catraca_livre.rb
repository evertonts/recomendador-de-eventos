require 'rss'
require 'open-uri'
require 'nokogiri'
require 'date'

class ParserCatracaLivre
	
	def initialize()
		@url = "http://catracalivre.com.br/feed"
	end

	def parse()
		open(@url) do |rss|
			feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
 	    event = Event.find_or_create_by_url item.link
				event.title = item.title
				event.description = item.description
			
				html = Nokogiri::HTML(item.content_encoded)
		
				html.css('.quando').each do |a|
					a.children.each do |c|
						event.date = c.content
					end
				end
				event.save!
			end
		end
	end
end

