describe EnMasse do
  include_context "whole and parts"

  shared_examples "each(&:save)" do
    let(:records) { 5.times.map{ Whole.new(parts: 3.times.map{ Part.new }) } }
    let(:record_ids) { records.map(&:id) }
    let(:dependents) { records.flat_map(&:parts) }
    let(:dependent_ids) { dependents.map(&:id) }
    let(:dependent_foreign_keys) { dependents.map(&:whole_id) }
    let(:record_creation_times) { Whole.pluck(:created_at) }
    let(:record_update_times) { Whole.pluck(:updated_at) }

    before do
      EnMasse.insert records
    end

    it "saves the records" do
      expect(Whole.all).to match_array records
    end

    it "updates the record ids" do
      expect(record_ids).to all be_present
    end

    it "saves dependent records" do
      expect(dependents.size).to be > 0
      expect(Part.all).to match_array dependents
    end

    it "updates the dependents foreign keys" do
      expect(dependent_foreign_keys).to all be_present
      expect(dependent_foreign_keys).to include *record_ids
    end

    it "sets record creation times" do
      expect(record_creation_times).to all be_a Time
    end
  end

  describe "::insert stubbed with each(&:save)" do
    before do
      allow(EnMasse).to receive(:insert) do |collection|
        collection.each(&:save)
      end
    end
    it_behaves_like "each(&:save)"
  end

  describe "::insert" do
    it_behaves_like "each(&:save)"
  end
end

