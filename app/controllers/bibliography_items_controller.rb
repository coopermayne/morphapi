class BibliographyItemsController < ApplicationController
  def index
    @bibs = BibliographyItem.all
  end

  def show
    @bib = BibliographyItem.find(params[:id])
  end
end
