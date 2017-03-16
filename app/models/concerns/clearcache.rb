module Clearcache

  extend ActiveSupport::Concern

  included do
    after_save :clear_all_cache
    after_destroy :clear_all_cache
  end

  def clear_all_cache
    case self
    when Person
      Rails.cache.delete('people')
      Rails.cache.delete("people#{self.id}")
    when NewsItem
      Rails.cache.delete('menu')
      (NewsItem.all.count/25).times do |n|
        Rails.cache.delete("news#{n}")
      end
    when Slide
      Rails.cache.delete('menu')
      Rails.cache.delete('videos')
    when Section
      Rails.cache.delete('menu')
      Rails.cache.delete('videos')
    when SearchResult
    else
      Rails.cache.clear
    end
  end

end
