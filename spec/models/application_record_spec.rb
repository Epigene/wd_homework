# frozen_string_literal: true

# spring rspec spec/models/application_record_spec.rb
RSpec.describe ApplicationRecord do
  # .where_field AKA .stamp
  describe ".where_field(field, gt: nil, gte: nil, lt: nil, lte: nil)" do
    # tested through Tag, a cheap example of using model
    let(:described_class) { Tag }

    let!(:tag1) do
      Timecop.freeze("2021-01-01 12:00") { create(:tag) }
    end

    let!(:tag2) do
      Timecop.freeze("2021-09-19 14:15:16") { create(:tag) }
    end

    it "returns correct collection of records based on stamp value" do
      # only later
      options = {gt: tag1.created_at}
      expect(collection(options)).to contain(tag2).and exclude(tag1)

      # only earlier
      options = {lt: tag2.created_at}
      expect(collection(options)).to contain(tag1).and exclude(tag2)

      # only earlier
      options = {gte: tag1.created_at, lt: tag2.created_at}
      expect(collection(options)).to contain(tag1).and exclude(tag2)

      # only later
      options = {lte: tag2.created_at, gt: tag1.created_at}
      expect(collection(options)).to contain(tag2).and exclude(tag1)
    end

    def collection(options)
      described_class.stamp(:created_at, **options)
    end
  end
end
