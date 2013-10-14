
class RepositoriesController < ActionController::Base
  respond_to :json

  def fetch_and_parse
    RepositoryWorker.perform_async params[:selector]
    render :json => {:result => 'done'}.to_json
  end
end
