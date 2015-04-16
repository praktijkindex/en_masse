describe EnMasse do
  describe "::validate" do
    let(:valid_records) { 3.times.map{double(valid?: true)} }
    let(:invalid_records) { 3.times.map{double(valid?: false)} }
    let(:records) { valid_records.zip(invalid_records).flatten }
    it "returns arrays of valid and invalid records" do
      valid, invalid = EnMasse.validate(records)
      expect(valid).to match_array valid_records
      expect(invalid).to match_array invalid_records
    end
  end
end
