class SearchResultsController < ApplicationController
  def index
    query = params[:q].gsub(/[^0-9a-z ]/i, '')
    @results = SearchResult.search(query)
  end
end
