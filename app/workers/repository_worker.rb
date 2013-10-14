require 'parser_catraca_livre'
require 'parser_uol'
require 'parser_folha'

class RepositoryWorker
  include Sidekiq::Worker
  def perform(selector)
    case selector
    when 'catraca_livre'
      ParserCatracaLivre
    when 'uol'
      ParserUol
    when 'folha'
      ParserFolha
    end.new.parse
  end
end

