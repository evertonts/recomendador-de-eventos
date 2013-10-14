require 'open-uri'
require 'nokogiri'
require 'date'

class ParserFolha
	
	def initialize(redis)
		@url = 'http://tools.folha.com.br/print?site=guia&url=http%3A%2F%2Fguia1.folha.com.br%2Fbusca%2Fshows%2F%3Fq%3D'
	  @redis = redis
		@redis_key = 'folha_last_success'
	end

  def blocked()
    date = @redis.get(@redis_key)
    not date.nil? and (Date.today - Date.parse(date)).to_i > 0
  end

  def update_redis()
    @redis.set(@redis_key, Date.today)
  end

	def parse()
	  html = Nokogiri::HTML.parse(open(@url), nil, 'iso-8859-1')
	  html.css('#roteiro > .element').each do |article|
			event = Event.find_or_create_by_id article.css('h1 a').first.attributes['href'].value
      event.title = article.css('h1 a').first.content.strip
      event.location = article.css('.servico').first.content.strip
      event.description = article.css('.editorial').first.content.strip
      #tags = article.css('h1 span b').first.content.strip
      event.save!
    end
    self.update_redis
	end
end

