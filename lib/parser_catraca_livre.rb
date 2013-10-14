require 'rss'
require 'open-uri'
require 'nokogiri'
require 'date'

class ParserCatracaLivre
	
	def initialize(url = "http://catracalivre.com.br/feed")
		@url = url
	  @redis = redis
		@redis_key = 'catraca_livre_last_success'
	end

  def blocked()
    date = @redis.get(@redis_key)
    not date.nil? and (Date.today - Date.parse(date)).to_i > 0
	end

  def update_redis()
    @redis.set(@redis_key, Date.today)
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
    self.update_redis
	end
end

