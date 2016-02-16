class SearchResultsController < ApplicationController
  def index
    @results = SearchResult.search(params[:q])
    render json: @results.to_json
  end
end
