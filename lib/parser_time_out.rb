require 'rss'
require 'open-uri'
require 'nokogiri'

class ParserTimeOut
	
	def initialize()
		@url = "http://www.timeout.com.br/sao-paulo/xmlapi/public"
		
	end
	
	def parse()
		open(@url) do |rss|
			feed = RSS::Parser.parse(rss)
			
			feed.items.each do |item|  
				event = Event.new
				event.title = item.title
				event.description = item.description
				event.url = item.link
			
				html = Nokogiri::HTML(item.description)
				html.css('strong').each do |a|
					a.children.each do |c|
						event.date = c.content
					end
				end
				event.save!
			end
		end
	end
end

