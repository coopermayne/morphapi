module Clearcache

  extend ActiveSupport::Concern

  included do
    after_save :clear_all_cache
  end

  def clear_all_cache
    Rails.cache.clear
  end

end
