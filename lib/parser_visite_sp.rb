require 'rss'
require 'open-uri'
require 'nokogiri'

class ParserVisiteSP
	
	def initialize()
		@url = "http://visitesaopaulo.com/rss/rss.xml"
	end
	
	def parse
		open(@url) do |rss|
		
			feed = RSS::Parser.parse(rss)
			feed.items.each do |item|
				evento = Event.find_or_create_by_url item.link
			
				open(item.link) do |page|
					html = Nokogiri::HTML(page)
					html.css('.content').each do |a|
						if a.css('h4.big').empty?
							a.css('div:not(.date)').each do |t| 
								evento.title = t.content
							end
						else
							a.css('h4.big').each do |t|
								evento.title = t.content
							end
						end

						a.css('td').each do |d|
							evento.location = d.next_element.content if d.content.match "Local:" 
							evento.location += ". " + d.next_element.content  if d.content.match "Endereço:" 
							evento.date = d.next_element.content if d.content.match "Horário:"
						end
				
						evento.description = a.css('table').first.next_element.content unless  a.css('table').empty?
					end
				end
				evento.save!
			end
		end
	end
	
end
