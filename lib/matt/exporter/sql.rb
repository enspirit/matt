module Matt
  module Exporter
    class Sql
      include Matt::Exporter

      def initialize(arg)
        case @config = arg
        when String
        when Hash
        when Sequel::Database
        when Matt::Datasource::Sql
        else
          raise ArgumentError, "Unable to use `#{arg}` to create an Sql exporter"
        end
      end
      attr_reader :config

      def sequel_db
        @sequel_db ||= case config
        when Sequel::Database      then config
        when Matt::Datasource::Sql then config.sequel_db
        else Sequel.connect(config)
        end
      end

      def export(measure, data)
        now = Time.now
        data = data.constants(:created_at => now)
        table = ensure_table!(measure)
        remove_old_data!(table, data)
        insert_new_data!(table, data)
      end

    private

      def remove_old_data!(table, data)
        dates = data.project([:at]).map{|t| t[:at] }
        count = table.where(:at => dates).delete
        info("Removed #{count} rows.")
        count
      end

      def insert_new_data!(table, data)
        data = data.to_a
        result = table.multi_insert(data)
        info("Inserted #{data.size} rows.")
        result
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
        existing = schema.map{|s| s.first } - [:created_at]
        missing  = fields - existing
        missing  = measure.dimensions.merge(measure.metrics).select{|x|
          missing.include?(x)
        }
        outdated = existing - fields
        return if missing.empty? && outdated.empty?
        debug("ALTER table #{tb_name}\n  Outdated: #{outdated.join(', ')}\n  New: #{missing.keys.join(', ')}")
        sequel_db.alter_table(tb_name) do
          outdated.each do |out|
            drop_column(out)
          end
          missing.each_pair do |mis, type|
            add_column(mis, type, null: true)
          end
        end
      end

      def create_table!(tb_name, measure, fields)
        debug("CREATE table #{tb_name}\n  Dimensions: #{measure.dimensions.keys.join(', ')}\n  Metrics: #{measure.metrics.keys.join(', ')}")
        sequel_db.create_table(tb_name) do
          column(:at, Date, :null => false)
          column(:created_at, :timestamp, :null => false)
          measure.dimensions.each do |name,type|
            column(name, type, :null => true)
          end
          measure.metrics.each do |name,type|
            column(name, type, :null => true)
          end
        end
      end

    end # class Sql
  end # module Exporter
end # module Matt
