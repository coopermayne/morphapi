# == Schema Information
#
# Table name: bibliography_items
#
#  id           :integer          not null, primary key
#  title        :string
#  description  :text
#  overview     :text
#  hit          :integer
#  author       :string
#  article_name :string
#  book_title   :string
#  subtitle     :string
#  publication  :string
#  publisher    :string
#  date         :string
#  pub_date     :date
#  pages        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  primary_id   :integer
#

class BibliographyItemsController < ApplicationController
  def index
    @bibs = BibliographyItem.all
  end

  def show
    @bib = BibliographyItem.find(params[:id])
  end
end
