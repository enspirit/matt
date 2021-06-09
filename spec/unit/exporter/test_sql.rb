require 'spec_helper'
module Matt
  module Exporter
    describe Sql do

      let(:sqlite_file) {
        Path.dir/'measures.sqlite'
      }

      let(:config) {
        "sqlite://#{sqlite_file}"
      }

      let(:exporter) {
        Sql.new(config)
      }

      let(:measure) {
        helloworld_config.ms.account_creations
      }

      context "when the table does not exist yet" do
        before do
          sqlite_file.unlink rescue nil
        end

        it 'works fine' do
          exporter.export(measure, measure.full_data)
          expect(exporter.sequel_db[:account_creations].count).to eql(4)
        end

        it 'is idempotent in terms of data' do
          exporter.export(measure, measure.full_data)
          expect(exporter.sequel_db[:account_creations].count).to eql(4)
          exporter.export(measure, measure.full_data)
          expect(exporter.sequel_db[:account_creations].count).to eql(4)
        end

        it 'is lets import gradually' do
          exporter.export(measure, measure.full_data.page([:at], 1, :page_size => 2))
          expect(exporter.sequel_db[:account_creations].count).to eql(2)
          exporter.export(measure, measure.full_data.page([:at], 2, :page_size => 2))
          expect(exporter.sequel_db[:account_creations].count).to eql(4)
        end
      end

      context "when the table is outdated" do
        before do
          sqlite_file.unlink rescue nil
          exporter.sequel_db.create_table(:account_creations) do
            column :at, Date
            column :count, Integer
            column :outdated, String
          end
          exporter.sequel_db[:account_creations].multi_insert([
            {:at => Date.parse("2019-01-01", :count => 92)}
          ])
        end

        it 'aligns the schema correctly' do
          exporter.export(measure, measure.full_data)
          expect(exporter.sequel_db[:account_creations].count).to eql(5)
        end
      end

    end
  end
end
