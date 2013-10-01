require 'parser_catraca_livre'

class CatracaLivreWorker
  include Sidekiq::Worker
  def perform(url)
    parser = ParserCatracaLivre.new url
    parser.parse
  end
end

