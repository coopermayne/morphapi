class SearchResultsController < ApplicationController
  def index
    @results = SearchResult.search(params[:q])
  end
end
