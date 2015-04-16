require_relative "en_masse/autoload"

module EnMasse
  def self.insert collection
    Inserts.new(collection).call
  end

  def self.validate collection
    collection.partition(&:valid?)
  end
end
