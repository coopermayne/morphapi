class Journalist < ActiveRecord::Base
  def self.to_csv
    attributes = %w{id email}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |journalist|
        csv << attributes.map{ |attr| journalist.send(attr) }
      end
    end
  end
end