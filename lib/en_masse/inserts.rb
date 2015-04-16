class EnMasse::Inserts
  using EnMasse::Refinements

  attr_reader :collection

  def initialize collection
    @collection = collection
    @collection += collect_new_dependents
  end

  def call
    ActiveRecord::Base.connection.transaction do
      by_model.each do |model, records|
        model.insert_collection(records)
      end
    end
  end

  private

  def by_model
    @by_model ||= collection.group_by(&:class)
  end

  def collect_new_dependents
    collection.flat_map{|record| record.new_dependents}.uniq
  end

end

