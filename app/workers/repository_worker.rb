require 'parser_catraca_livre'
require 'parser_uol'
require 'parser_folha'
require 'redis'
require 'date'

class RepositoryWorker
  include Sidekiq::Worker

  def initialize()
    @redis = Redis.new
  end

  def perform(selector)
    parser = case selector
    when 'catraca_livre'
      ParserCatracaLivre
    when 'uol'
      ParserUol
    when 'folha'
      ParserFolha
    end.new @redis
    return if parser.blocked
    parser.parse
  end
end

