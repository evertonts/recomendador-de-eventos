require 'open-uri'
require 'nokogiri'
require 'date'

class ParserUol
	
	def initialize()
	  @path = 'http://guia.uol.com.br/sao-paulo/shows/'
		@url = 'http://guia.uol.com.br/_include/v1/web/servico/ajax.htm?type=guia&subtype=indice-guia&sigla=sao-paulo&template=show_house&order=az&tag=shws&eof=true&page=1'
	end

	def parse()
	  html = Nokogiri::HTML.parse(open(@url), nil, 'utf-8')
	  html.css('article').each do |article|
	    resource = article.css('*[itemprop=name]').first.attributes['href'].value
			event = Event.find_or_create_by_url(@path + resource)
      event.title = article.css('*[itemprop=name]').first.children.first.content.strip
      event.location = article.css('*[itemprop=streetAddress]').first.children.first.content.strip
      begin
        event.description = article.css('*[itemprop=description]').first.children.first.content.strip
      rescue
        # nada faz
      end
      event.save
    end
	end
	
end

