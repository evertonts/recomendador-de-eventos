require 'parser_catraca_livre'
require 'parser_uol'
require 'parser_folha'
require 'parser_visite_sp'
require 'date'

class RepositoryWorker
  include Sidekiq::Worker

  def initialize()
  end

  def perform(selector)
    parser = case selector
    when 'catraca_livre'
      ParserCatracaLivre
    when 'uol'
      ParserUol
    when 'folha'
      ParserFolha
    when 'visite_sp'
    	ParserVisiteSP
    end.new
    parser.parse
  end
end

