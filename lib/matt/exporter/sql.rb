module Matt
  module Exporter
    class Sql

      def initialize(config)
        @config = config
      end
      attr_reader :config

      def sequel_db
        @sequel_db ||= Sequel.connect(config)
      end

      def export(measure, data)
        table = ensure_table!(measure)
        remove_old_data!(table, data)
        insert_new_data!(table, data)
      end

    private

      def remove_old_data!(table, data)
        dates = data.project([:at]).map{|t| t[:at] }
        table.where(:at => dates).delete
      end

      def insert_new_data!(table, data)
        table.multi_insert(data.to_a)
      end

      def ensure_table!(measure)
        tb_name = measure.name.to_sym
        fields = [:at] + measure.dimensions.keys + measure.metrics.keys
        if sequel_db.table_exists?(tb_name)
          align_table!(tb_name, measure, fields)
        else
          create_table!(tb_name, measure, fields)
        end
        sequel_db[tb_name]
      end

      def align_table!(tb_name, measure, fields)
        schema   = sequel_db.schema(tb_name)
        existing = schema.map{|s| s.first }
        missing  = fields - existing
        missing  = measure.dimensions.merge(measure.metrics).select{|x|
          missing.include?(x)
        }
        outdated = existing - fields
        return if missing.empty? && outdated.empty?
        sequel_db.alter_table(tb_name) do
          outdated.each do |out|
            drop_column(out)
          end
          missing.each_pair do |mis, type|
            add_column(mis, type)
          end
        end
      end

      def create_table!(tb_name, measure, fields)
        sequel_db.create_table(tb_name) do
          column(:at, Date)
          measure.dimensions.each do |name,type|
            column(name, type)
          end
          measure.metrics.each do |name,type|
            column(name, type)
          end
          primary_key [:at] + measure.dimensions.keys
        end
      end

    end # class Sql
  end # module Exporter
end # module Matt
