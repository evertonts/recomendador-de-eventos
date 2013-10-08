
class RepositoriesController < ActionController::Base
  respond_to :json

  def fetch_and_parse
    case params[:selector]
    when 'catraca_livre'
      url = params[:url] or 'http://catracalivre.com.br/feed'
      CatracaLivreWorker.perform_async url
    when 'uol'
      UolWorker.perform_async
    end
    render :json => {:result => 'done'}.to_json
  end
end
