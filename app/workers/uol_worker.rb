require 'parser_uol'

class UolWorker
  include Sidekiq::Worker
  def perform
    ParserUol.new.parse
  end
end

