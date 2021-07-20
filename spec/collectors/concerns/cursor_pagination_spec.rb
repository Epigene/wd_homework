# frozen_string_literal: true

# spring rspec spec/collectors/concerns/cursor_pagination_spec.rb
RSpec.describe CursorPagination, instance_name: :collector do
  let(:collector) { mock_includer.new(params: params) }

  # basically acts as a very naive Tag resource collector.
  let(:mock_includer) do
    Class.new do
      include ServiceApi
      include CursorPagination

      private

        def base_collection
          Tag.all
        end
    end
  end

  describe "#call" do
    subject(:call) { collector.call }

    let_it_be(:tag1) { create(:tag, title: "First") }
    let_it_be(:tag2) { create(:tag, title: "Second") }
    let_it_be(:tag3) { create(:tag, title: "Third") }
    let_it_be(:tag4) { create(:tag, title: "Fourth") }

    before(:each, :with_records) do
      tag1
      tag2
      tag3
      tag4
    end

    context "when params specify no page data", :with_records do
      let(:params) { {} }

      before { stub_const("#{described_class}::DEFAULT_PAGE_SIZE", 2) }

      it "returns first records and default page size (2 for test purposes)" do
        is_expected.to eq([tag1, tag2])
      end
    end

    context "when request specifies :after cursor and page size" do
      let(:params) { {page: {after: tag1.id.to_s, size: "2"}} }

      it "returns records after cursor value and specified page size" do
        is_expected.to eq([tag2, tag3])
      end
    end

    context "when request specifies :before cursor and page size, tricky" do
      context "when the paged records fall in the middle of available records" do
        let(:params) { {page: {before: tag3.id.to_s, size: "1"}} }

        it "returns records newer than cursor value and specified page size" do
          is_expected.to eq([tag2])
        end
      end

      context "when the paged records cover the first record" do
        let(:params) { {page: {before: tag3.id.to_s, size: "3"}} }

        it "returns records newer than cursor value, paging and ordering correctly" do
          is_expected.to eq([tag1, tag2])
        end
      end
    end

    context "when a negative page size param is given" do
      let(:params) { {page: {size: "-1"}} }

      it "returns a negative page size error hash" do
        expect(call.to_s).to(
          contain('"detail"=>"page[size] must be a positive integer')
        )
      end
    end

    context "when a page size param that exceeds max page size is given" do
      let(:params) { {page: {size: mock_includer::MAX_PAGE_SIZE.next.to_s}} }

      it "returns a 'max page size exceeded' error hash" do
        expect(call.to_s).to(
          contain('"detail"=>"Page of size 51 was requested, but 50 is the maximum."')
        )
      end
    end

    context "when a negative after cursor is given" do
      let(:params) { {page: {after: "-1"}} }

      it "returns a 'negative after cursor' error hash" do
        expect(call.to_s).to(
          contain('"detail"=>"page[after] must be a positive integer')
        )
      end
    end

    context "when a negative before cursor is given" do
      let(:params) { {page: {before: "-1"}} }

      it "returns a 'negative before cursor' error hash" do
        expect(call.to_s).to(
          contain('"detail"=>"page[before] must be a positive integer')
        )
      end
    end

    context "when a range pagination is attempted" do
      let(:params) { {page: {before: "1", after: "1"}} }

      it "returns a 'unsupported range pagination attempted' error hash" do
        expect(call.to_s).to(
          contain('"detail"=>"Both page[before] and page[after] supplied')
        )
      end
    end
  end
end
