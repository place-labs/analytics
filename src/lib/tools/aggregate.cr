module PlaceOS::Analytics
  # Methods for aggregating individual location metrics into higher level
  # groupings.
  module Tools::Aggregate
    extend self

    def mean(values : Array(Float64))
      compacted = values.compact
      compacted.sum / compacted.size.to_f
    end

    # Aggregate a set of single values.
    def mean(value_hash : Hash(String, Float64))
      mean value_hash.values
    end

    # Aggegate a set of values by a location attribute
    def mean(value_hash : Hash(String, Float64), group_by attr : String)
      values = {} of String => Float64
      value_hash.each do |id, value|
        location = Model::Location.find id
        group = location ? location[attr].to_s : "unknown"
        values[group] ||= 0.0
        values[group] = (values[group] + value) / 2.0
      end
      values
    end

    # Aggregate a set of uniform series, producing a single series with each
    # point representing the mean value of all components at that time.
    def mean_series(value_hash : Hash(String, Array(Float64?)))
      value_hash.values.reduce do |acc, i|
        acc.zip(i).map do |a, b|
          if a && b
            (a + b) / 2.0
          elsif a
            a
          elsif b
            b
          else
            nil
          end
        end
      end
    end
  end
end
