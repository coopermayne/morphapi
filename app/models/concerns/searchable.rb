module Searchable
  # using this module... Award, Bib, News, Person, Project
  
  extend ActiveSupport::Concern

  included do
    after_create :autocreate_searchable
    after_commit :update_search_content
  end

  def autocreate_searchable
    self.search_result = SearchResult.create!
  end

  def update_search_content
    img_url = self.primary_image ? self.primary_image.name.thumb.url : nil

    if self.index_image
      img_url = self.index_image.name.thumb.url
    end

    attr = {
      uid: self.id,
      title: self.class==Person ? self.name : self.title,
      thumb: img_url,
      description: self.class==Person ? self.description : self.overview
    }

    u_attr = case 
             when self.class == Award
               {
                 section: "about",
                 sorting_type: "award",
                 content: "#{self.projects.map(&:title).join(" ")}"
               }
             when self.class == BibliographyItem
               {
                 section: "about",
                 sorting_type: "media",
                 content: "#{self.projects.map(&:title).join(" ")} #{[self.article_name, self.author, self.publication, self.publisher].join(" ")}"
               }
             when self.class == NewsItem
               {
                 section: "news"
               }
             when self.class == Person
               {
                 section: "about",
                 sorting_type: "people",
                 content: "#{roles.map(&:project).map(&:title).join(" ")}"
               }

             when self.class == Project
               if self.section.nil?
                 sec = nil
                 st = nil
               elsif ["Publications", "Videos"].include? self.section.title
                 sec = "about"
                 st = "media"
               else
                 sec = self.section.title.downcase
                 st = nil
               end
               {
                 section: sec,
                 sorting_type: st,
                 content: "#{title} #{self.project_types.map(&:title).join(" ")}"
               }
             else
               {}
             end

    self.search_result.update_attributes attr.merge(u_attr)
  end

end
